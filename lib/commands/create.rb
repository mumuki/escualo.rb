command 'create service' do |c|
  c.syntax = 'escualo create service'
  c.description = 'Setup a micro-service deployment'
  c.action do |args, options|
    say "...."
  end
end

command 'create site' do |c|
  c.syntax = 'escualo create site'
  c.description = 'Setup an static site deployment'
  c.action do |args, options|
    say "...."
  end
end

command 'create executable' do |c|
  c.syntax = 'escualo create executable'
  c.description = 'Setup an executable command deployment'
  c.action do |args, options|
    say "...."
  end
end