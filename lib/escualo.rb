require 'timeout'

def timeout(*args, &block)
  Timeout.timeout(*args, &block)
end

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
require_relative './escualo/ppa'
require_relative './escualo/gems'
require_relative './escualo/base'
require_relative './escualo/bootstrap'
require_relative './escualo/script'
require_relative './escualo/plugin'
require_relative './escualo/remote'
require_relative './escualo/artifact'
