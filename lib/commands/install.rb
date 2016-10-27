command 'install' do |c|
  c.syntax = 'escualo install <plugin>'
  c.description = "Install plugin on host. Valid plugins are #{Escualo::Installers::PLUGINS.join(', ')}"
  c.option '--nginx-conf FILENAME', String, 'ningix config file, only for nginx plugin'
  c.option '--rabbit-admin-password PASSWORD', String, 'rabbitmq admin password, only for rabbit plugin'
  c.option '-f', '--force', TrueClass, 'Force bootstrap even if already done?'

  c.ssh_action do |args, options, ssh|
    plugin = args.first
    say "Installing #{plugin}"

    installer = Escualo::Installers.load plugin

    if !options.force && installer.check(ssh)
      say "Nothing to do. Plugin #{plugin} is already installed"
      say 'Use --force to reinstall it anyway'
    else
      log = installer.run ssh, options

      if installer.check ssh
        say 'Installed successfully!'
      else
        say "Something went wrong. Last output was: \n#{log}"
      end
    end
  end
end
