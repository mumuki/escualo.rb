command 'install' do |c|
  c.syntax = 'escualo install <plugin>'
  c.description = "Install plugin on host. Valid plugins are #{Escualo::Installers::PLUGINS.join(', ')}"
  c.option '--nginx-conf FILENAME', String, 'ningix config file, only for nginx plugin'
  c.ssh_action do |args, options, ssh|
    installer = Escualo::Installers.load args.first
    if installer.check ssh
      say "Nothing to do. Plugin #{args.first} is already installed"
    else
      log = installer.run ssh, options

      if installer.check ssh
        say "Installed successfully!"
      else
        say "Something went wrong. Last output was: \n#{log}"
      end
    end
  end
end
