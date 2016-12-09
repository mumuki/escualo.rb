class Escualo::Session::Local < Escualo::Session
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