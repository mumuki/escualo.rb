command 'plugin install' do |c|
  c.syntax = 'escualo plugin install <plugin>'
  c.description = "Install plugin on host. Valid plugins are #{Escualo::Plugin::PLUGINS.join(', ')}"
  c.option '--nginx-conf FILENAME', String, 'ningix config file, only for nginx plugin'
  c.option '--rabbit-admin-password PASSWORD', String, 'rabbitmq admin password, only for rabbit plugin'
  c.option '--pg-version VERSION', String, 'PostgreSQL major and minor version. Default is 9.3, only for postgre plugin'

  c.option '-f', '--force', TrueClass, 'Force reinstalling even if already done'
  c.ssh_action do |args, options, ssh|
    options.default pg_version: '9.3'

    plugin = args.first
    say "Installing #{plugin}"

    installer = Escualo::Plugin.load plugin

    do_unless installer.check(ssh, options),
              "Plugin #{plugin} is already installed",
              options do

      step "Installing plugin #{plugin}" do
        if Escualo::Plugin.run_and_check installer, ssh, options
          say 'Installed successfully!'
        else
          abort 'Installation of plugin failed'
        end
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
