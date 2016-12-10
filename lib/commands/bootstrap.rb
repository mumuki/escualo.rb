command 'bootstrap' do |c|
  c.syntax = 'escualo bootstrap'
  c.description = 'Prepare environment to be an escualo host'
  c.option '--swap', TrueClass, 'Setup swap?'
  c.option '--env ENVIRONMENT', String, 'Environment. Valid options are development and production. default is production'
  c.option '--with-rbenv', TrueClass, 'Use rbenv instead of native ruby installation'

  c.session_action do |_args, options, session|
    options.default env: 'production'

    exit_if('This host has already been bootstrapped', options) do
      Escualo::Env.present?(session, :ESCUALO_BASE_VERSION) && Escualo::Gems.installed?(session)
    end

    step 'Configuring variables...', options do
      Escualo::Env.setup session
      Escualo::Env.set_builtins session, options
    end

    step 'Configuring locales...', options do
      Escualo::Base.configure_locales session
    end

    step 'Installing base software', options do
      Escualo::Base.install session
    end

    step 'Adding package repositories', options do
      Escualo::Base.add_repositories session
    end

    step 'Enabling swap...', options do
      Escualo::Base.enable_swap session
    end if options.swap

    step 'Installing Ruby...', options do
      Escualo::Ruby.install session, options
    end

    step 'Installing gems...', options do
      Escualo::Gems.install session
    end

    step 'Setup artifact directories...', options do
      Escualo::Artifact.setup session
    end
  end
end
