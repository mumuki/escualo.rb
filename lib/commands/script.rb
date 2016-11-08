def run_commands_for!(script, extra='', ssh, options)
  script.map { |it| "escualo #{it} #{extra}" }.each do |command|
    puts "Running `#{command}`"
    ssh.shell.perform! command, options
  end
end

def ssh_options
  [$hostname.try { |it| "--hostname #{it}" },
   $username.try { |it| "--username #{it}" },
   $password.try { |it| "--password #{it}" },
   $ssh_key.try { |it| "--ssh-key #{it}" },
   $ssh_port.try { |it| "--ssh-port #{it}" }
  ].compact.join(' ')
end

command 'script' do |c|
  c.syntax = 'escualo script <FILE>'
  c.description = 'Runs a escualo configuration'
  c.action do |args, options|
    file = YAML.load_file args.first
    local_ssh = Net::SSH::Connection::LocalSession.new

    step 'Running local commands...' do
      run_commands_for! file['local'], ssh_options, local_ssh, options
    end

    step 'Running remote commands...' do
      Net::SSH.start($hostname, $username, $ssh_options.compact) do |ssh|
        run_commands_for! file['remote'], ssh, options
      end
    end

    step 'Running deploy commands...' do
      run_commands_for! file['deploy'], ssh_options, local_ssh, options
    end
  end
end