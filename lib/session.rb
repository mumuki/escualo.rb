class Net::SSH::Connection::Session
  def upload_template!(destination, name, bindings)
    Mumukit::Core::Template
        .new(File.join(__dir__, 'templates', "#{name}.erb"), bindings)
        .with_tempfile!('template') do |file|
      scp.upload! file, destination
    end
  end

  def tell!(command)
    channel = self.open_channel do |ch|
      ch.exec command do |ch, success|
        raise 'could not execute command' unless success
        ch.on_data do |c, data|
          $stdout.print data
        end
        ch.on_extended_data do |c, type, data|
          $stderr.print data
        end
      end
    end
    channel.wait
  end

  def shell
    Shell.new self
  end

  def perform!(command, options)
    if options.verbose
      tell! command
    else
      exec! command
    end
  end

  class Shell
    attr_reader :ssh

    def initialize(ssh)
      @ssh = ssh
    end

    def perform!(command, options)
      ssh.perform! wrap(command), options
    end

    def exec!(command)
      ssh.exec! wrap(command)
    end

    def tell!(command)
      ssh.tell! wrap(command)
    end

    private

    def wrap(command)
      "bash -i -s <<EOBASH
#{command}
EOBASH"
    end
  end
end