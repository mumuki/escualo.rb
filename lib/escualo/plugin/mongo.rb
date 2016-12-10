module Escualo::Plugin
  class Mongo
    def run(session, _options)
      session.tell! 'apt-get install -y --force-yes mongodb-org'
      session.tell_all! "echo '' >> /etc/init/mongodb",
                        "echo 'respawn' >> /etc/init/mongodb"
    end

    def check(session, _options)
      session.ask('mongod --version').include? 'db version v3.2' rescue false
    end
  end
end
