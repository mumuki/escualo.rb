require 'fileutils'
require 'open3'

module Net::SSH
  def self.with_session(options, &block)
    if options.delete(:local)
      block.call(Net::SSH::Connection::LocalSession.new)
    else
      start(options.delete(:hostname),
            options.delete(:username),
            options.compact) do |ssh|
        block.call(ssh)
      end
    end
  end
end

class Net::SSH::Connection::LocalSession
  include Net::SSH::Connection::Perform
  include Net::SSH::Connection::Upload

  def exec!(command)
    Open3.capture2e(command).first rescue 'command not found'
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