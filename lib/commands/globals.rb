global_option '-h', '--hostname HOSTNAME', String, 'The host to connect. Defaults to "localhost"'
global_option '-u', '--username USERNAME', String, 'The username to connect. Defaults to "root"'

global_option '-i', '--ssh-key PRIVATE_KEY', String, 'An optional private key'
global_option '--ssh-port PORT', String, 'The ssh port to connect. Defaults to 22'
global_option '--ssh-password PASSWORD', String, 'An optional remote password'

global_option '--dockerized', TrueClass, 'Generate a docker script instead of running the commands'
global_option '--unoptimized-dockerfile', TrueClass, 'Do not optimize commands when run dockerized'

global_option '--verbose', TrueClass, 'Dumps extra output'

global_option '-f', '--force', TrueClass, 'Force command run'
