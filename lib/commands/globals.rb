$hostname = 'localhost'
$username = 'root'
$ssh_options = {}
$ssh_remote = false

global_option '-h', '--hostname HOSTNAME', String, 'The host to connect. Defaults to "localhost"' do |hostname|
  $hostname = hostname
  $ssh_remote = true
end

global_option '-u', '--username USERNAME', String, 'The username to connect. Defaults to "root"' do |username|
  $username = username
  $ssh_remote = true
end

global_option '--password PASSWORD', String, 'An optional remote password' do |password|
  $password = password
  $ssh_options[:password] = password
  $ssh_remote = true
end

global_option '-i', '--ssh-key PRIVATE_KEY', String, 'An optional private key' do |private_key|
  $ssh_key = private_key
  $ssh_options[:keys] = [private_key]
  $ssh_remote = true
end

global_option '--ssh-port PORT', String, 'The ssh port to connect. Defaults to 22' do |port|
  $ssh_port = port
  $ssh_options[:port] = port
  $ssh_remote = true
end

global_option '--verbose', TrueClass, 'Dumps extra output'