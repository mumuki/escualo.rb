command 'remote attach' do |c|
  c.syntax = 'escualo remote attach <name>'
  c.description = "Adds the given artifact to current's repository"
  c.option '--repo-path PATH', String, 'Sets the git dir'


  c.local_session_action do |args, options, session|
    raise 'missing service name!' unless args.first

    options.default repo_path: Dir.pwd
    session_options = Escualo::Session.parse_session_options options

    Escualo::Remote.attach session, options.repo_path, args.first, session_options
  end
end

command 'remote show' do |c|
  c.syntax = 'escualo remote show'
  c.description = "Show attached artifacts to current's repository"
  c.option '--repo-path PATH', String, 'Sets the git dir'

  c.local_session_action do |_args, options, session|
    options.default repo_path: Dir.pwd

    Escualo::Remote.remotes(session, options.repo_path).each { |it| say it }
  end
end

command 'remote push' do |c|
  c.syntax = 'escualo remote push'
  c.description = 'Pushes artifact at current repository'
  c.local_session_action do |_args, _options, session|
    Escualo::Remote.push session, Dir.pwd
  end
end

