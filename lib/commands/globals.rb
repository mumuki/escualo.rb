$hostname = 'localhost'
$username = 'root'
$ssh_options = {}

global_option '-h', '--hostname HOSTNAME', String, 'The host to connect. Defaults to "localhost"' do |hostname|
  $hostname = hostname
end

global_option '-u', '--username USERNAME', String, 'The username to connect. Defaults to "root"' do |username|
  $username = username
end

global_option '--password PASSWORD', String, '' do |password|
  $ssh_options[:password] = password
end

global_option '-i', '--ssh-key PRIVATE_KEY', String, '' do |private_key|
  $ssh_options[:keys] = [private_key]
end

global_option '--ssh-port PORT', String, '' do |port|
  $ssh_options[:port] = port
end

global_option '--verbose', TrueClass, 'Dumps extra output'