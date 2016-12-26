command 'artifact list' do |c|
  c.syntax = 'escualo artifact list'
  c.description = 'Lists artifacts on host'
  c.session_action do |args, options, session|
    Escualo::Artifact.list(session).each do |artifact|
      say artifact
    end
  end
end

command 'artifact destroy' do |c|
  c.syntax = 'escualo artifact destroy <NAME>'
  c.description = 'Destroys an artifact on host'
  c.session_action do |args, options, session|
    raise 'artifact destroy takes exactly one argument' if args.length > 1

    Escualo::Artifact.destroy(session, args.first)
  end
end

command 'artifact create service' do |c|
  c.syntax = 'escualo artifact create service <NAME> <PORT>'
  c.description = 'Setup a micro-service deployment'

  c.session_action do |args, options, session|
    name = args.first
    port = args.second

    raise 'missing service name!' unless name
    raise 'missing port!' unless port

    exit_if("Service #{name} already created", options) { Escualo::Artifact.present?(session, name) }

    launch_command = "exec bundle exec rackup -o 0.0.0.0 -p #{port} > rack.log"
    install_command='bundle install --without development test'

    step 'Creating init scripts...', options do
      Escualo::Artifact.create_scripts_dir session, name
      Escualo::Artifact.create_init_script session,
                                           name: name,
                                           service: true,
                                           install_command: install_command
      Escualo::Artifact.create_codechange_script session, name
    end

    step 'Configuring upstart...', options do
      Escualo::Artifact.configure_upstart session, name: name, launch_command: launch_command
    end

    step 'Configuring monit...', options do
      Escualo::Artifact.configure_monit session, name: name, port: port
    end

    step 'Creating push infrastructure', options do
      Escualo::Artifact.create_push_infra session, name: name, service: true
    end
  end
end

command 'artifact create site' do |c|
  c.syntax = 'escualo artifact create site <NAME>'
  c.description = 'Setup an static site deployment'

  c.session_action do |args, options, session|
    name = args.first
    raise 'missing site name!' unless name

    exit_if("Site #{name} already created", options) { Escualo::Artifact.present?(session, name) }

    step 'Creating init scripts...', options do
      Escualo::Artifact.create_scripts_dir session, name
      Escualo::Artifact.create_init_script session, name: name, static: true
    end

    step 'Creating push infrastructure', options do
      Escualo::Artifact.create_push_infra session, name: name, static: true
    end
  end
end

command 'artifact create executable' do |c|
  c.syntax = 'escualo artifact create executable <NAME>'
  c.description = 'Setup an executable command deployment'

  c.session_action do |args, options, session|
    name = args.first
    raise 'missing executable name!' unless name

    exit_if("Executable #{name} already created", options) { Escualo::Artifact.present?(session, name) }
    step 'Creating init scripts...', options do
      Escualo::Artifact.create_scripts_dir session, name
      Escualo::Artifact.create_init_script session, name: name, executable: true
    end

    step 'Creating push infrastructure', options do
      Escualo::Artifact.create_push_infra session, name: name, executable: true
    end
  end
end