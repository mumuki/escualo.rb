$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'escualo'


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