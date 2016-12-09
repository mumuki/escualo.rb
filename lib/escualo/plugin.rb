module Escualo
  module Plugin
    PLUGINS = %w(node haskell docker postgre nginx rabbit mongo monit)

    def self.load(name)
      "Escualo::Plugin::#{name.capitalize}".constantize.new
    end
  end
end

require_relative './plugin/docker'
require_relative './plugin/monit'
require_relative './plugin/haskell'
require_relative './plugin/mongo'
require_relative './plugin/nginx'
require_relative './plugin/node'
require_relative './plugin/postgres'
require_relative './plugin/rabbit'