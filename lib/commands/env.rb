command 'env list' do |c|
  c.syntax = 'escualo env list'
  c.description = 'List escualo variables on host'
  c.session_action do |_args, _options, session|
    say Escualo::Env.list session
  end
end

def parse_args_variables(args)
  args.map { |it| it.split('=') }.to_h
end

command 'env set' do |c|
  c.syntax = 'escualo env set <NAME>=<VALUE> [<NAME>=<VALUE>,...<NAME>=<VALUE>]'
  c.description = 'Sets one or more escualo variables on host'
  c.session_action do |args, _options, session|
    Escualo::Env.set session, parse_args_variables(args)
  end
end

command 'env unset' do |c|
  c.syntax = 'escualo env unset <NAME> [<NAME>,...<NAME>]'
  c.description = 'Unset escualo variables on host'
  c.session_action do |args, _options, session|
    Escualo::Env.unset session, args
  end
end

command 'env clean' do |c|
  c.syntax = 'escualo env clean'
  c.option '--env ENVIRONMENT', String, 'Environment. Valid options are development and production. default is production'

  c.description = 'Unset all escualo variables on host'
  c.session_action do |_args, options, session|
    options.default env: 'production'

    Escualo::Env.clean session, options
  end
end