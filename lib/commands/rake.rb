command 'rake' do |c|
  c.syntax = 'escualo rake <SERVICE_NAME> <TASK>'
  c.description = 'Run rake task on host'
  c.session_action do |args, _options, session|
    name = args.first
    task = args.second

    session.tell! "cd /var/www/#{name} && rake #{task}"
  end
end

