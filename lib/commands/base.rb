command 'base' do |c|
  c.syntax = 'escualo base'
  c.description = 'Install essential libraries'

  c.ssh_action do |_args, options, ssh|
    Escualo::Base.install_base ssh, options
  end
end
