command 'rake' do |c|
  c.syntax = 'escualo rake <SERVICE_NAME> <TASK>'
  c.description = 'Run rake task on host'
  c.ssh_action do |args, options, ssh|
    name = args.first
    task = args.second
    ssh.shell.perform! %Q{
      cd /var/www/#{name}
      rake #{task}
    }, options
  end
end

