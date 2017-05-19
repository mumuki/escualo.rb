module Escualo::Plugin
  class Mongo
    def run(session, _options)
      Escualo::AptGet.install session, 'mongodb-org'
      session.tell_all! "echo '' >> /etc/init/mongodb.conf",
                        "echo 'respawn' >> /etc/init/mongodb.conf"
    end

    def installed?(session, _options)
      session.check? 'mongod --version', 'db version v3.2'
    end
  end
end
