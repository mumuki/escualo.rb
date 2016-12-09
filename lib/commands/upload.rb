command 'upload' do |c|
  c.syntax = 'escualo upload <FILE> <DESTINATION>'
  c.description = 'Upload file to host'
  c.session_action do |args, _options, session|
    session.upload! args.first, args.second
  end
end