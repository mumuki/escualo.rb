module Escualo
  module Script
    def self.each_command(script, extra='', &block)
      script.map { |it| "escualo #{it} #{extra}" }.each(&block) if script
    end

    def self.delegated_options(options)
      [options.hostname.try { |it| "--hostname #{it}" },
       options.username.try { |it| "--username #{it}" },
       options.password.try { |it| "--password #{it}" },
       options.ssh_key.try { |it| "--ssh-key #{it}" },
       options.ssh_port.try { |it| "--ssh-port #{it}" },
       options.trace && '--trace',
       options.verbose && '--verbose'
      ].compact.join(' ')
    end

    class Mode
      def run_commands_for!(script, extra='', ssh, options)
        Escualo::Script.each_command script, extra do |command|
          run_command! command, ssh, options
        end
      end
    end

    class Standard < Mode
      def start!(*)
      end

      def run_command!(command, ssh, options)
        ssh.shell.perform! command, options
      end

      def finish!
      end
    end

    class Dockerized < Mode
      attr_accessor :dockerfile

      def start!(options)
        @dockerfile = "
FROM #{base_image options}
MAINTAINER #{ENV['USER']}
RUN apt-get update && apt-get install ruby ruby-dev build-essential -y
RUN gem install escualo -v #{Escualo::VERSION}
"
      end

      def base_image(options)
        if options.base_image == 'ubuntu'
          'ubuntu:xenial'
        elsif options.base_image == 'debian'
          'debian:jessie'
        else
          raise "Unsupported base image #{options.base_image}. Only debian and ubuntu are supported"
        end
      end

      def run_command!(command, ssh, options)
        @dockerfile << "RUN #{command}\n"
      end

      def finish!
        File.write('Dockerfile', @dockerfile)
      end
    end
  end
end

