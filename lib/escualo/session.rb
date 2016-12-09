require 'fileutils'
require 'open3'

class Net::SSH::Connection::Session
  def stream!(command)
    channel = self.open_channel do |channel|
      channel.exec command do |ch, success|
        raise 'could not execute command' unless success
        ch.on_data do |c, data|
          yield :stdout, data unless garbage? data
        end
        ch.on_extended_data do |c, type, data|
          yield :stderr, data unless garbage? data
        end
        ch.on_request('exit-status') do |c, data|
          exit_code = data.read_long
        end
      end
    end
    channel.wait
    raise 'command failed' if exit_code != 0
    nil
  end
end

class Escualo::Session
  attr_accessor :options

  def initialize(options={})
    @options = options
  end

  def tell!(command)
    if options.verbose
      exec! command
    else
      stream! command
    end
  end

  def upload_template!(destination, name, bindings)
    Mumukit::Core::Template
        .new(File.join(__dir__, '..', 'templates', "#{name}.erb"), bindings)
        .with_tempfile!('template') do |file|
      upload! file, destination
    end
  end

  def self.parse_session_options(options)
    struct username: options.username || 'root',
           hostname: options.hostname || 'localhost',
           ssh_options: {
               keys: [options.ssh_key].compact,
               port: options.ssh_port || 22
           },
           verbose: options.verbose,
           local: options.hostname.blank? && options.username.blank? && options.ssh_key.blank? && options.ssh_port.blank?,
           dockerized: options.dockerized
  end

  def self.within(options, &block)
    session_options = parse_session_options options

    if session_options.dockerized
      within_dockerized_session session_options, options, &block
    elsif session_options.local
      block.call(Escualo::Session::Local.new session_options)
    else
      within_ssh_session(session_options, &block)
    end
  end

  def self.within_dockerized_session(session_options, options, &block)
    session = Escualo::Session::Docker.new session_options
    session.start! options
    block.call(session)
    session.finish! options
  end

  def self.within_ssh_session(session_options, &block)
    Net::SSH.start(
        session_options.hostname,
        session_options.username,
        session_options.ssh_options) do |ssh|
      block.call(Escualo::Session::Remote.new ssh, session_options)
    end
  end

  class Remote < Escualo::Session
    def initialize(ssh, options)
      super(options)
      @ssh = ssh
    end

    def upload!(file, destination)
      scp.upload! file, destination
    end

    def exec!(command)
      ask command
      nil
    end

    def ask(command)
      out = []
      @ssh.stream! wrap(command) do |_stream, data|
        out << data
      end
      out
    end

    def stream!(command)
      command = wrap(command)
      @ssh.stream! command do |stream, data|
        if stream == :stdout
          $stdout.print data
        else
          stderr.print data
        end
      end
    end

    private

    def garbage?(data)
      data.start_with?('bash: cannot set terminal process group') || data.start_with?('bash: no job control in this shell')
    end

    def wrap(command)
      "bash -i -s <<EOBASH
#{command.gsub('$', '\$')}
EOBASH"
    end
  end

  class Local < Escualo::Session
    def exec!(command)
      ask command
      nil
    end

    def ask(command)
      out, status = Open3.capture2e(command)
      raise out unless status.success?
      out
    end

    def stream!(command)
      Open3.popen2e command do |_input, output, wait|
        output.each do |line|
          $stdout.print line
        end
        raise "command #{command} failed" unless wait.value.success?
      end
    end

    def upload!(file, destination)
      FileUtils.cp file, destination
    end
  end

  class Docker < Escualo::Session
    attr_accessor :dockerfile

    def tell!(command)
      dockerfile << "RUN #{command}\n"
    end

    def upload!(file, destination)
      dockerfile << "COPY #{file.path} #{destination}\n"
    end

    def ask(*)
      raise 'can not ask on a docker session'
    end

    def start!(options)
      if options.write_dockerfile
        @dockerfile = "
FROM #{base_image options}
MAINTAINER #{ENV['USER']}"
      else
        @dockerfile = ''
      end
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

    def finish!(options)
      if options.write_dockerfile
        File.write('Dockerfile', dockerfile)
      else
        puts dockerfile
      end
    end

    def self.started(options = struct)
      new.tap do |it|
        it.start!(options)
      end
    end
  end
end