module Escualo::Plugin
  class Mongo
    def run(session, options)
      session.tell! %Q{
        echo 'deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list && \
        apt-get update && \
        apt-get install -y --force-yes mongodb-org && \
        echo '' >> /etc/init/mongodb && \
        echo 'respawn' >> /etc/init/mongodb
      }
    end

    def check(session, _options)
      session.ask('mongod --version').include? 'db version v3.2' rescue false
    end
  end
end
