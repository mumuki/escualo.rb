command 'plugin install' do |c|
  c.syntax = 'escualo plugin install <plugin>'
  c.description = "Install plugin on host. Valid plugins are #{Escualo::Plugin::PLUGINS.join(', ')}"
  c.option '--nginx-conf FILENAME', String, 'ningix config file, only for nginx plugin'
  c.option '--rabbit-admin-password PASSWORD', String, 'rabbitmq admin password, only for rabbit plugin'
  c.option '-f', '--force', TrueClass, 'Force reinstalling even if already done'

  c.ssh_action do |args, options, ssh|
    plugin = args.first
    say "Installing #{plugin}"

    installer = Escualo::Plugin.load plugin

    do_unless installer.check(ssh),
              "Plugin #{plugin} is already installed",
              options do

      step "Installing plugin #{plugin}" do
        log = installer.run ssh, options
      end

      if installer.check ssh
        say 'Installed successfully!'
      else
        say "Something went wrong. Last output was: \n#{log}"
      end
    end
  end
end

command 'plugin list' do |c|
  c.syntax = 'escualo plugin list'
  c.description = 'List installed plugins on host'

  c.ssh_action do |_args, _options, ssh|
    Escualo::Plugin::PLUGINS.each do |plugin|
      if Escualo::Plugin.load(plugin).check ssh
        say plugin
      end
    end
  end
end
