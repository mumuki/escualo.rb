command 'deploy' do |c|
  c.syntax = 'escualo deploy <name> <repo>'
  c.description = 'Deploys repository to the given executable, service or site'
  c.option '--tag GIT_TAG', String, 'Github tag to deploy'
  c.local_session_action do |args, options, session|
    session_options = Escualo::Session.parse_session_options(options)

    Dir.mktmpdir do |dir|
      step 'Cloning repository...', options do
        Escualo::Remote.clone session, dir, args.second, options
        Escualo::Remote.attach session, dir, args.first, session_options
      end

      step 'Pushing to remote...', options do
        Escualo::Remote.push session, dir
      end
    end
  end
end