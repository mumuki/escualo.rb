class Commander::Command
  def ssh_action(&block)
    action do |args, options|
      Net::SSH.start($hostname, $username, $ssh_options.compact) do |ssh|
        block.call(args, options, ssh)
      end
    end
  end
end