command 'script' do |c|
  c.syntax = 'escualo script <FILE>'
  c.description = 'Runs a escualo configuration'
  c.action do |args, options|
    file = YAML.load_file args.first

    step 'Bootstrapping host..' do
      puts "escualo #{file['boostrap']}"
      say %x{escualo #{file['boostrap']}}
    end

    step 'Provisioning host' do
      commands = file['script'].map { |it| "escualo #{it}" }
      Net::SSH.start($hostname, $username, $ssh_options.compact) do |ssh|
        commands.each do |command|
          say ssh.exec! command
        end
      end
    end
  end
end