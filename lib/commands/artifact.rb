command 'artifact list' do |c|
  c.syntax = 'escualo artifact list'
  c.description = 'Lists artifacts on host'
  c.ssh_action do |args, options, ssh|
    Escualo::Artifact.list(ssh).each do |artifact|
      say artifact
    end
  end
end

command 'artifact destroy' do |c|
  c.syntax = 'escualo artifact destroy <NAME>'
  c.description = 'Destroys an artifact on host'
  c.ssh_action do |args, options, ssh|
    name = args.first

    Escualo::Artifact.destroy(ssh, name)

    if !Escualo::Artifact.present? ssh, name
      say "#{name} destroyed successfully"
    else
      abort "Could not destroy artifact #{name}"
    end
  end
end

def check_created(kind, name)
  if Escualo::Artifact.present?(ssh, name)
    say "#{kind.titleize} #{name} created successfully"
    say "Now you can deploy this #{kind}"
  else
    abort "Failed to create artifact #{name}"
  end
end

command 'artifact create service' do |c|
  c.syntax = 'escualo artifact create service <NAME> <PORT>'
  c.description = 'Setup a micro-service deployment'
  c.option '-f', '--force', TrueClass, 'Force creation even if already done'

  c.ssh_action do |args, options, ssh|
    name = args.first
    port = args.second

    do_unless Escualo::Artifact.present?(ssh, name),
              "Service #{name} already created",
              options do
      launch_command = "exec bundle exec rackup -o 0.0.0.0 -p #{port} > rack.log"
      install_command='bundle install --without development test'

      step 'Creating init scripts...' do
        Escualo::Artifact.create_scripts_dir ssh, name
        Escualo::Artifact.create_init_script ssh,
                                             name: name,
                                             service: true,
                                             install_command: install_command
        Escualo::Artifact.create_codechange_script ssh, name
      end

      step 'Configuring upstart...' do
        Escualo::Artifact.configure_upstart ssh, name: name, launch_command: launch_command
      end

      step 'Configuring monit...' do
        Escualo::Artifact.configure_monit ssh, name: name, port: port
      end

      step 'Creating push infrastructure' do
        Escualo::Artifact.create_push_infra ssh, name: name, service: true
      end

      check_created 'service', name
    end
  end
end

command 'artifact create site' do |c|
  c.syntax = 'escualo artifact create site <NAME>'
  c.description = 'Setup an static site deployment'
  c.option '-f', '--force', TrueClass, 'Force creation even if already done'

  c.ssh_action do |args, options, ssh|
    name = args.first

    do_unless Escualo::Artifact.present?(ssh, name),
              "Site #{name} already created",
              options do
      step 'Creating init scripts...' do
        Escualo::Artifact.create_scripts_dir ssh, name
        Escualo::Artifact.create_init_script ssh, name: name, static: true
      end

      step 'Creating push infrastructure' do
        Escualo::Artifact.create_push_infra ssh, name: name, static: true
      end
      check_created 'site', name
    end
  end
end

command 'artifact create executable' do |c|
  c.syntax = 'escualo artifact create executable <NAME>'
  c.description = 'Setup an executable command deployment'
  c.option '-f', '--force', TrueClass, 'Force creation even if already done'

  c.ssh_action do |args, options, ssh|
    name = args.first

    do_unless Escualo::Artifact.present?(ssh, name),
              "Executable #{name} already created",
              options do
      step 'Creating init scripts...' do
        Escualo::Artifact.create_scripts_dir ssh, name
        Escualo::Artifact.create_init_script ssh, name: name, executable: true
      end

      step 'Creating push infrastructure' do
        Escualo::Artifact.create_push_infra ssh, name: name, executable: true
      end
      check_created 'executable', name
    end
  end
end