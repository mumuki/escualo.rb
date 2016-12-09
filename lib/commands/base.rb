command 'base' do |c|
  c.syntax = 'escualo base'
  c.description = 'Install essential libraries'

  c.session_action do |_args, _options, session|
    Escualo::Base.install_base session
  end
end
