module Escualo
  module Installers
    PLUGINS = %w(node haskell docker postgre nginx rabbit mongo)

    def self.load(name)
      "Escualo::Installers::#{name.capitalize}".constantize.new
    end
  end
end

require_relative "./installers/docker"
require_relative "./installers/haskell"
require_relative "./installers/mongo"
require_relative "./installers/nginx"
require_relative "./installers/node"
require_relative "./installers/postgre"
require_relative "./installers/rabbit"