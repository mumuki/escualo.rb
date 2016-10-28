command 'create service' do |c|
  c.syntax = 'escualo create service <NAME> <PORT>'
  c.description = 'Setup a micro-service deployment'
  c.ssh_action do |args, options, ssh|
    name = args.first
    port = args.second

    launch_command = "exec bundle exec rackup -o 0.0.0.0 -p #{port} > rack.log"
    install_command='bundle install --without development test'

    Escualo::Artifacts.create_scripts_dir ssh, name
    Escualo::Artifacts.create_init_script ssh,
                                          name: name,
                                          service: true,
                                          install_command: install_command
    Escualo::Artifacts.create_codechange_script ssh, name
    Escualo::Artifacts.configure_upstart ssh, name: name, lanunch_comand: launch_command
    Escualo::Artifacts.configure_monit ssh, name
    Escualo::Artifacts.create_push_infra ssh, name: name, service: true
  end
end

command 'create site' do |c|
  c.syntax = 'escualo create site <NAME>'
  c.description = 'Setup an static site deployment'
  c.ssh_action do |args, options, ssh|
    name = args.first

    Escualo::Artifacts.create_scripts_dir ssh, name
    Escualo::Artifacts.create_init_script ssh, name: name, static: true
    Escualo::Artifacts.create_push_infra ssh, name: name, static: true
  end
end

command 'create executable' do |c|
  c.syntax = 'escualo create executable <NAME>'
  c.description = 'Setup an executable command deployment'
  c.ssh_action do |args, options, ssh|
    name = args.first

    Escualo::Artifacts.create_scripts_dir ssh, name
    Escualo::Artifacts.create_init_script ssh, name: name, program: true
    Escualo::Artifacts.create_push_infra ssh, name: name, program: true
  end
end