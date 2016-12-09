command 'script' do |c|
  c.syntax = 'escualo script <FILE>'
  c.description = 'Runs a escualo configuration'
  c.option '--dockerized', TrueClass, 'Create a Dockerfile instead of running commands'
  c.option '--development', TrueClass, 'Use local escualo gemspec instead of fetching from internet'
  c.option '--base-image BASE_IMAGE', String, 'Default base image. Only for dockerized runs'

  c.action do |args, options|
    options.default base_image: 'ubuntu'

    if options.dockerized
      mode = Escualo::Script::Dockerized.new
    else
      mode = Escualo::Script::Standard.new
    end

    mode.start! options

    file = YAML.load_file args.first

    local_ssh = Net::SSH::Connection::LocalSession.new
    delegated_options = Escualo::Script.delegated_options options

    step 'Running local commands...' do
      mode.run_commands_for! file['local'], delegated_options, local_ssh, options
    end
    step 'Running remote commands...' do
      Net::SSH.with_session(ssh_session_options) do |ssh|
        mode.run_commands_for! file['remote'], ssh, options
      end
    end

    step 'Running deploy commands...' do
      mode.run_commands_for! file['deploy'], delegated_options, local_ssh, options
    end

    mode.finish!
  end
end