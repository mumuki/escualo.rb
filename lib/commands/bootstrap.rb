def ask_monit_password(options)
  password = ask('Monit Password: ') { |q| q.echo = '*' }
  options.default monit_password: password
end

command 'bootstrap' do |c|
  c.syntax = 'escualo bootstrap'
  c.description = 'Prepare environment to be an escualo host'
  c.option '--swap', TrueClass, 'Setup swap?'
  c.option '--monit-version VERSION', String, 'Monit version'
  c.option '--monit-password PASSWORD', String, 'Monit password. Will be prompted otherwise'
  c.option '--no-monit', TrueClass, 'Skip monit installation'
  c.option '--env ENVIRONMENT', String, 'Environment. Valid options are development and production. default is production'
  c.option '--with-rbenv', TrueClass, 'Use rbenv instead of native ruby installation'

  c.option '-f', '--force', TrueClass, 'Force bootstrap even if already done?'

  c.ssh_action do |_args, options, ssh|
    ask_monit_password(options) unless  options.monit_password || options.no_monit
    options.default monit_version: '5.16',
                    env: 'production'

    do_unless Escualo::Env.present?(ssh, :ESCUALO_BASE_VERSION),
              'This host has already been bootstrapped',
              options do
      step 'Configuring variables...' do
        Escualo::Env.setup ssh
        Escualo::Env.set_builtins ssh, options
      end

      step 'Installing base software...' do
        Escualo::Bootstrap.install_base ssh, options
        Escualo::Bootstrap.install_ruby ssh, options
      end

      step 'Installing and configuring monit...' do
        Escualo::Bootstrap.setup_monit ssh, options
      end unless options.no_monit

      step 'Enabling swap...' do
        Escualo::Bootstrap.enable_swap ssh
      end if options.swap

      step 'Installing gems...' do
        Escualo::Bootstrap.install_gems ssh, options
      end

      step 'Setup artifact directories...' do
        Escualo::Artifact.setup ssh
      end

      if Escualo::Env.present?(ssh, :ESCUALO_BASE_VERSION)
        say 'Host bootstrapped successfully '
      else
        abort 'bootstrapping failed'
      end
    end
  end
end
