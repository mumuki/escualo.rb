require 'net/ssh'
require 'net/scp'
require 'yaml'
require 'mumukit/core'

module Escualo
end

require_relative './template'
require_relative './ssh'

require_relative './escualo/version'
require_relative './escualo/env'
require_relative './escualo/bootstrap'
require_relative './escualo/plugin'
require_relative './escualo/remote'
require_relative './escualo/artifact'
