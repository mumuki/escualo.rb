command 'plugin install' do |c|
  c.syntax = 'escualo plugin install <plugin>'
  c.description = "Install plugin on host. Valid plugins are #{Escualo::Plugin::PLUGINS.join(', ')}"
  c.option '--nginx-conf FILENAME', String, 'ningix config file, only for nginx plugin'

  c.option '--rabbit-admin-password PASSWORD', String, 'rabbitmq admin password, only for rabbit plugin'

  c.option '--pg-version VERSION', String, 'PostgreSQL major and minor version. Default is 9.3, only for postgre plugin'
  c.option '--pg-username USERNAME', String, 'PostgreSQL username'
  c.option '--pg-password PASSWORD', String, 'PostgreSQL password'

  c.option '--monit-version VERSION', String, 'Monit version. Default is 5.16'
  c.option '--monit-password PASSWORD', String, 'Monit password. Required with monit plugin'

  c.session_action do |args, options, session|
    options.default pg_version: '9.3',
                    monit_version: '5.16'

    plugin = args.first
    installer = Escualo::Plugin.load plugin

    exit_if("Plugin #{plugin} is already installed", options) { installer.check(session, options) }

    step "Installing plugin #{plugin}", options do
      installer.run session, options
    end
  end
end

command 'plugin list' do |c|
  c.syntax = 'escualo plugin list'
  c.description = 'List installed plugins on host'

  c.session_action do |_args, _options, session|
    Escualo::Plugin::PLUGINS.each do |plugin|
      say plugin if Escualo::Plugin.load(plugin).check session
    end
  end
end
