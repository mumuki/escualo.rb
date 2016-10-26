require 'net/ssh'
require 'net/scp'
require 'securerandom'
require 'mumukit/core'

module Escualo
end

require_relative './session'
require_relative './template'

require_relative './escualo/version'
require_relative './escualo/vars'
require_relative './escualo/bootstrap'
require_relative './escualo/installers'
require_relative './escualo/remote'