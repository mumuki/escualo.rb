require 'fileutils'
require 'open3'

module Net::SSH
  def self.with_session(options, &block)
    if options.delete(:debug)
      block.call(Net::SSH::Connection::DebuggingSession.new(options))
    elsif options.delete(:local)
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

class Net::SSH::Connection::DebuggingSession
  include Net::SSH::Connection::Perform
  include Net::SSH::Connection::Upload

  def initialize(options)
    @options = options
    @commands_queue = []
  end

  def exec!(command)
    @commands_queue << {command: command, options: @options}
    open('escualo.log', 'a') { |f| f.puts @commands_queue.last[:command] }
  end

  def upload_file!(file, destination)
    exec! "upload #{file} #{destination}"
  end

  def tell!(command)
    exec! command
  end

  def shell
    self
  end
end