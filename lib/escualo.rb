require 'net/ssh'
require 'net/scp'
require 'securerandom'
require 'yaml'
require 'mumukit/core'

module Escualo
end

require_relative './session'
require_relative './template'

require_relative './escualo/version'
require_relative './escualo/env'
require_relative './escualo/bootstrap'
require_relative './escualo/plugin'
require_relative './escualo/remote'
require_relative './escualo/artifact'