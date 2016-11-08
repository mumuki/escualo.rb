command 'bootstrap' do |c|
  c.syntax = 'escualo bootstrap'
  c.description = 'Prepare environment to be an escualo host'
  c.option '--swap', TrueClass, 'Setup swap?'
  c.option '--monit-version VERSION', String, 'Monit version'
  c.option '--monit-password PASSWORD', String, 'Monit password. Will be prompted otherwise'
  c.option '-f', '--force', TrueClass, 'Force bootstrap even if already done?'

  c.ssh_action do |_args, options, ssh|
    unless options.monit_password
      password = ask('Monit Password: ') { |q| q.echo = '*' }
      options.default monit_password: password
    end
    options.default monit_version: '5.16'

    do_unless Escualo::Env.present?(ssh, :ESCUALO_BASE_VERSION),
              'This host has already been bootstrapped',
              options do
      step 'Configuring variables...' do
        Escualo::Env.setup ssh
        Escualo::Env.set_builtins ssh
      end

      step 'Installing base software...' do
        Escualo::Bootstrap.install_base ssh, options
      end

      step 'Installing and configuring monit...' do
        Escualo::Bootstrap.setup_monit ssh, options
      end

      step 'Enabling swap...' do
        Escualo::Bootstrap.enable_swap ssh
      end if options.swap

      step 'Installing gems...' do
        Escualo::Bootstrap.install_gems ssh, options
      end

      step 'Setup artifact directories...' do
        Escualo::Artifact.setup ssh
      end
    end
  end
end
