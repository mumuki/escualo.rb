command 'bootstrap' do |c|
  c.syntax = 'escualo bootstrap'
  c.description = 'Prepare environment to be an escualo host'
  c.option '--swap', TrueClass, 'Setup swap?'
  c.option '--env ENVIRONMENT', String, 'Environment. Valid options are development and production. default is production'
  c.option '--with-rbenv', TrueClass, 'Use rbenv instead of native ruby installation'
  c.option '-f', '--force', TrueClass, 'Force bootstrap even if already done?'

  c.ssh_action do |_args, options, ssh|
    options.default env: 'production'

    do_unless Escualo::Bootstrap.check(ssh), 'This host has already been bootstrapped', options do
      step 'Configuring variables...' do
        Escualo::Env.setup ssh
        Escualo::Env.set_builtins ssh, options
      end

      step 'Installing base software...' do
        Escualo::Bootstrap.install_base ssh, options
        Escualo::Bootstrap.install_ruby ssh, options
      end

      step 'Enabling swap...' do
        Escualo::Bootstrap.enable_swap ssh
      end if options.swap

      step 'Installing gems...' do
        Escualo::Gems.install ssh, options
      end

      step 'Setup artifact directories...' do
        Escualo::Artifact.setup ssh
      end

      if Escualo::Bootstrap.check ssh
        say 'Host bootstrapped successfully '
      else
        abort 'bootstrapping failed'
      end
    end
  end
end
