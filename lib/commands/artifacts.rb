command 'artifacts list' do |c|
  c.syntax = 'escualo artifacts list'
  c.description = 'Lists artifacts on host'
  c.ssh_action do |args, options, ssh|
    Escualo::Artifacts.list(ssh).each do |artifact|
      say artifact
    end
  end
end
