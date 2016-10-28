command 'upload' do |c|
  c.syntax = 'escualo upload <FILE> <DESTINATION>'
  c.description = 'Upload file to host'
  c.ssh_action do |args, options, ssh|
    ssh.scp.upload! args.first, args.second
  end
end