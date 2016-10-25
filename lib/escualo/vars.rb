module Escualo
  module Vars
    def self.setup(ssh)
      ssh.exec! "mkdir -p ~/.escualo/vars"
      ssh.exec! "'for var in ~/.escualo/vars/*; do source $var; done' > ~/.escualorc"
      ssh.exec! "echo 'export ESCUALO_BASE_VERSION=#{Escualo::BASE_VERSION}' >> ~/.escualorc"
      ssh.exec! "chmod u+x ~/.escualorc"
      ssh.exec! "'source ~/.escualorc' >> ~/.bashrc"
    end

    def self.list(ssh)
      ssh.exec!("cat ~/.escualo/vars/*").gsub("export ", '')
    end

    def self.clean(ssh)
      ssh.exec!("rm ~/.escualo/vars/*")
    end

    def self.set(variables, ssh)
      variables.each do |key, value|
        ssh.exec!("'export #{key}=#{value}' > ~/.escualo/vars/#{key}")
      end
    end

    def self.locale_variables
      %w{LANG LC_ALL LC_NAME LC_PAPER LC_ADDRESS LC_NUMERIC LC_MONETARY LC_TELEPHONE LC_MEASUREMENT}.map do |it|
        [it, 'en_US.UTF-8']
      end.to_h
    end

    def self.production_variables
      %w{RAILS_ENV NODE_ENV RACK_ENV}.map do |it|
        [it, 'production']
      end.to_h
    end

    def self.locale_export
      locale_variables.map { |key, value| "#{key}=#{value}" }.join(' ')
    end
  end
end