command 'script' do |c|
  c.syntax = 'escualo script <FILE>'
  c.description = 'Runs a escualo configuration'
  c.option '--dockerized', TrueClass, 'Create a Dockerfile instead of running commands'
  c.option '--write-dockerfile', TrueClass, 'Write a complete Dockerfile instead of writing to stdout. Default is false'
  c.option '--dockerfile PATH', String, 'Destination Dockerfile. Default is `Dockerfile`'
  c.option '--development', TrueClass, 'Use local escualo gemspec instead of fetching from internet'
  c.option '--base-image BASE_IMAGE', String, 'Default base image. Only for dockerized runs'

  c.action do |args, options|
    options.default base_image: 'ubuntu',
                    dockerfile: 'Dockerfile'
    file = YAML.load_file args.first
    delegated_options = Escualo::Script.delegated_options options

    Escualo::Session.within(options) do |session|
      Escualo::Script.run!(session, $PROGRAM_NAME, file, delegated_options)
    end
  end
end