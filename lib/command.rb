class Commander::Command
  def ssh_action(&block)
    action do |args, options|
      if $ssh_remote
        Net::SSH.start($hostname, $username, $ssh_options.compact) do |ssh|
          block.call(args, options, ssh)
        end
      else
        block.call(args, options, Net::SSH::Connection::LocalSession.new)
      end
    end
  end
end