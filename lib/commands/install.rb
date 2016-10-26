command 'install' do |c|
  c.syntax = 'escualo install <plugin>'
  c.description = "Install plugin on host. Valid plugins are #{Escualo::Installers::PLUGINS.join(', ')}"
  c.option '--nginx-conf FILENAME', String, 'ningix config file, only for nginx plugin'
  c.ssh_action do |args, options, ssh|
    installer = Escualo::Installers.load args.first
    installer.run ssh, options
  end
end
