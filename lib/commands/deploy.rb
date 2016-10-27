command 'deploy' do |c|
  c.syntax = 'escualo deploy [<name> <repo>]'
  c.description = 'Deploys repository to the given executable, service or site'
  c.option '--tag GIT_TAG', String, 'Github tag to deploy'
  c.action do |args, options|
    if args.empty?
      Escualo::Remote.push Dir.pwd
    else
      Dir.mktmpdir do |dir|
        step 'Cloning repository...' do
          Escualo::Remote.clone dir, args.second, options
          Escualo::Remote.attach dir, args.first
        end

        step 'Pushing to remote...'do
          Escualo::Remote.push dir
        end
      end
    end
  end
end