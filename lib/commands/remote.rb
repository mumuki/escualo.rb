command 'remote attach' do |c|
  c.syntax = 'escualo remote attach <name>'
  c.description = "Adds the given executable, service or site to current's repository"
  c.option '--repo-path PATH', String, 'Sets the git dir'

  c.action do |args, options|
    options.default repo_path: Dir.pwd

    Escualo::Remote.attach options.repo_path, args.first
  end
end

command 'remote show' do |c|
  c.syntax = 'escualo remote show'
  c.description = "Show attached executables, services and sites to current's repository"
  c.option '--repo-path PATH', String, 'Sets the git dir'

  c.action do |args, options|
    options.default repo_path: Dir.pwd

    Escualo::Remote.remotes(options.repo_path).each { |it| say it }
  end
end