$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'escualo'
require 'docker'

def raw_escualo(command)
  %x{bin/escualo #{command}}
end

def escualo(command, env)
  %x{bin/escualo script spec/data/#{env} --dockerized --trace --development}
  %x{gem build escualo.gemspec}
  image = Docker::Image.build_from_dir('.')
  result = image.run("escualo #{command}").tap do |container|
    container.commit
  end.logs(stdout: true, stderr: true)
  [result, 0]
rescue => e
  [e, -1]
end
