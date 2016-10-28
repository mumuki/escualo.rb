$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'escualo'



def vagrant_up
  @vagrant_up ||= ENV['TEST_ESCUALO_WITH_VAGRANT']
end

def escualo(args)
  options = '--hostname 127.0.0.1 ' +
  '--username root ' +
  '--password 123456 ' +
  '--ssh-port 2222 '
  raw_escualo args, options
end

def raw_escualo(args, options='')
  %x{./bin/escualo #{args} #{options}}
end

unless vagrant_up
  puts '[WARNING] '
  puts '[WARNING] ***************************'
  puts '[WARNING] *Not running vagrant tests*'
  puts '[WARNING] ***************************'
  puts '[WARNING] '
  puts '[WARNING] You have not enabled TEST_ESCUALO_WITH_VAGRANT=true variable'
  puts '[WARNING] Please have a look at readme for instructions about installing vagrant machine and running with vagrant support'
  puts '[WARNING] '
end