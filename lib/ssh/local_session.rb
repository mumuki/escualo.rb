require 'fileutils'
require 'open3'

class Net::SSH::Connection::LocalSession
  include Net::SSH::Connection::Perform
  include Net::SSH::Connection::Upload

  def exec!(command)
    Open3.capture2e(command) rescue 'command not found'
  end

  def upload_file!(file, destination)
    FileUtils.cp file, destination
  end

  def tell!(command)
    Open3.popen2e command do |_input, output|
      output.each do |line|
        $stdout.print line
      end
    end
  end

  def shell
    self
  end
end