$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'escualo'
require 'docker'

def raw_escualo(command)
  %x{bin/escualo #{command}}
end

def logonly_escualo(command, options='')
  Open3.exec! "bin/escualo #{command} #{options} --logonly --trace"
end

def logonly
  session = Escualo::Session::Logonly.started
  yield session
  session.log
end
