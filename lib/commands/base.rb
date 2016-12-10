command 'base' do |c|
  c.syntax = 'escualo base'
  c.description = 'Install essential libraries'

  c.session_action do |_args, options, session|
    step 'Configuring variables...', options do
      Escualo::Env.setup session
      Escualo::Env.set_builtins session, options
    end

    step 'Configuring locales...', options do
      Escualo::Base.configure_locales session
    end

    step 'Installing base software', options do
      Escualo::Base.install_base session
    end

    step 'Adding package repositories', options do
      Escualo::Base.add_repositories session
    end
  end
end
