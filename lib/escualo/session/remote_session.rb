class Escualo::Session::Remote < Escualo::Session
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