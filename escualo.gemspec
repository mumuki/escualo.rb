# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'escualo/version'

Gem::Specification.new do |spec|
  spec.name          = 'escualo'
  spec.version       = Escualo::VERSION
  spec.authors       = ['Franco Leonardo Bulgarelli']
  spec.email         = ['flbulgarelli@yahoo.com.ar']

  spec.summary       = 'Mumuki Platform provisioning tool'
  spec.description   = 'escualo.rb is command-line tools that implements of the escualo provisioning format used by Mumuki Platform.
                        It allows to deploy mumuki artifacts to any host'
  spec.homepage      = 'http://github.com/mumuki/escualo.rb'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = Dir['lib/**/*', 'bin/**/*']
  spec.require_paths = %w(lib bin)
  spec.executables   = ['escualo']

  spec.add_dependency 'commander', '~> 4.4'
  spec.add_dependency 'net-ssh', '~> 2.9'
  spec.add_dependency 'net-scp', '~> 1.2'
  spec.add_dependency 'mumukit-core'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
