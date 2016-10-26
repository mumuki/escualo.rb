command 'vars list' do |c|
  c.syntax = 'escualo vars list'
  c.description = 'List escualo variables on host'
  c.ssh_action do |args, options, ssh|
    say Escualo::Vars.list ssh
  end
end


def parse_args_variables(args)
  args.map { |it| it.split('=') }.to_h
end

command 'vars set' do |c|
  c.syntax = 'escualo vars set <NAME>=<VALUE> [<NAME>=<VALUE>,...<NAME>=<VALUE>]'
  c.description = 'Sets one or more escualo variables on host'
  c.ssh_action do |args, options, ssh|
    Escualo::Vars.set ssh, parse_args_variables(args)
  end
end

command 'vars unset' do |c|
  c.syntax = 'escualo vars unset <NAME> [<NAME>,...<NAME>]'
  c.description = 'Unset escualo variables on host'
  c.ssh_action do |args, options, ssh|
    Escualo::Vars.unset ssh, args
  end
end

command 'vars clean' do |c|
  c.syntax = 'escualo vars clean'
  c.description = 'Unset all escualo variables on host'
  c.ssh_action do |args, options, ssh|
    Escualo::Vars.clean ssh
  end
end