class Commander::Command
  def ssh_action(&block)
    action do |args, options|
      if $ssh_remote
        say "Connecting to remote host #{$hostname}... " if options.verbose
      else
        say 'Running commands locally... ' if options.verbose
      end
      Net::SSH.with_session(ssh_session_options) { |ssh| block.call(args, options, ssh) }
    end
  end
end