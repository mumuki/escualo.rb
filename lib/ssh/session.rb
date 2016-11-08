class Net::SSH::Connection::Session
  include Net::SSH::Connection::Perform
  include Net::SSH::Connection::Upload

  def upload_file!(file, destination)
    scp.upload! file, destination
  end

  def tell!(command)
    channel = self.open_channel do |ch|
      ch.exec command do |ch, success|
        raise 'could not execute command' unless success
        ch.on_data do |c, data|
          $stdout.print data unless garbage? data
        end
        ch.on_extended_data do |c, type, data|
          $stderr.print data unless garbage? data
        end
      end
    end
    channel.wait
  end

  def shell
    Shell.new self
  end

  private

  def garbage?(data)
    data.start_with?('bash: cannot set terminal process group') || data.start_with?('bash: no job control in this shell')
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