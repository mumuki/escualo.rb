$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'escualo'
require 'docker'

def raw_escualo(command)
  %x{bin/escualo #{command}}
end

def dockerized_escualo(command, options='')
  Open3.exec! "bin/escualo #{command} #{options} --dockerized --trace"
end

def dockerized
  session = Escualo::Session::Docker.started
  yield session
  session.dockerfile
end