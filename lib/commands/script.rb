def run_commands_for!(script, extra='', ssh, options)
  Escualo::Script.each_command script, extra do |command|
    puts "Running `#{command}`"
    ssh.shell.perform! command, options
  end
end

command 'script' do |c|
  c.syntax = 'escualo script <FILE>'
  c.description = 'Runs a escualo configuration'
  c.action do |args, options|
    file = YAML.load_file args.first
    ssh_local_session_options = options.__hash__.merge(local: true)
    delegated_options = Escualo::Script.delegated_options options

    step 'Running local commands...' do
      Net::SSH.with_session(ssh_local_session_options) do |ssh|
        run_commands_for! file['local'], delegated_options, ssh, options
      end
    end

    step 'Running remote commands...' do
      Net::SSH.with_session(ssh_session_options) do |ssh|
        run_commands_for! file['remote'], ssh, options
      end
    end

    step 'Running deploy commands...' do
      Net::SSH.with_session(ssh_local_session_options) do |ssh|
        run_commands_for! file['deploy'], delegated_options, ssh, options
      end
    end
  end
end