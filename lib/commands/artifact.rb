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
    say "#{name} destroyed successfully"
  end
end

def say_created(kind, name)
  say "#{kind.titleize} #{name} created successfully"
  say "Now you can deploy this #{kind}"
end

command 'artifact create service' do |c|
  c.syntax = 'escualo artifact create service <NAME> <PORT>'
  c.description = 'Setup a micro-service deployment'
  c.ssh_action do |args, options, ssh|
    name = args.first
    port = args.second

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
      Escualo::Artifact.configure_upstart ssh, name: name, lanunch_comand: launch_command
    end

    step 'Configuring monit...' do
      Escualo::Artifact.configure_monit ssh, name
    end

    step 'Creating push infrastructure' do
      Escualo::Artifact.create_push_infra ssh, name: name, service: true
    end

    say_created 'service', name
  end
end

command 'artifact create site' do |c|
  c.syntax = 'escualo artifact create site <NAME>'
  c.description = 'Setup an static site deployment'
  c.ssh_action do |args, options, ssh|
    name = args.first

    step 'Creating init scripts...' do
      Escualo::Artifact.create_scripts_dir ssh, name
      Escualo::Artifact.create_init_script ssh, name: name, static: true
    end

    step 'Creating push infrastructure' do
      Escualo::Artifact.create_push_infra ssh, name: name, static: true
    end
    say_created 'site', name
  end
end

command 'artifact create executable' do |c|
  c.syntax = 'escualo artifact create executable <NAME>'
  c.description = 'Setup an executable command deployment'
  c.ssh_action do |args, options, ssh|
    name = args.first

    step 'Creating init scripts...' do
      Escualo::Artifact.create_scripts_dir ssh, name
      Escualo::Artifact.create_init_script ssh, name: name, program: true
    end

    step 'Creating push infrastructure' do
      Escualo::Artifact.create_push_infra ssh, name: name, program: true
    end
    say_created 'executable', name
  end
end