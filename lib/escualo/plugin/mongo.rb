module Escualo::Plugin
  class Mongo
    def run(session, _options)
      session.tell_all! %Q{echo 'deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list},
                        'apt-get update'
      session.tell! 'apt-get install -y --force-yes mongodb-org'
      session.tell_all! "echo '' >> /etc/init/mongodb",
                        "echo 'respawn' >> /etc/init/mongodb"
    end

    def check(session, _options)
      session.ask('mongod --version').include? 'db version v3.2' rescue false
    end
  end
end
