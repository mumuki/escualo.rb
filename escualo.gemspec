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

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir["bin/**"] + Dir["lib/**"]
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'commander'
  spec.add_dependency 'net-ssh'
  spec.add_dependency 'net-scp'
  spec.add_dependency 'mumukit-core'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
