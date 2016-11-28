command 'env list' do |c|
  c.syntax = 'escualo env list'
  c.description = 'List escualo variables on host'
  c.ssh_action do |args, options, ssh|
    say Escualo::Env.list ssh
  end
end


def parse_args_variables(args)
  args.map { |it| it.split('=') }.to_h
end

command 'env set' do |c|
  c.syntax = 'escualo env set <NAME>=<VALUE> [<NAME>=<VALUE>,...<NAME>=<VALUE>]'
  c.description = 'Sets one or more escualo variables on host'
  c.ssh_action do |args, options, ssh|
    Escualo::Env.set ssh, parse_args_variables(args)
  end
end

command 'env unset' do |c|
  c.syntax = 'escualo env unset <NAME> [<NAME>,...<NAME>]'
  c.description = 'Unset escualo variables on host'
  c.ssh_action do |args, options, ssh|
    Escualo::Env.unset ssh, args
  end
end

command 'env clean' do |c|
  c.syntax = 'escualo env clean'
  c.description = 'Unset all escualo variables on host'
  c.ssh_action do |args, options, ssh|
    Escualo::Env.clean ssh, options
  end
end