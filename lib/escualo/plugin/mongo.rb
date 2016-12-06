module Escualo::Plugin
  class Mongo
    def run(ssh, options)
      ssh.shell.perform! %Q{
        echo 'deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list && \
        apt-get update && \
        apt-get install -y --force-yes mongodb-org && \
        echo '' >> /etc/init/mongodb && \
        echo 'respawn' >> /etc/init/mongodb
      }, options
    end

    def check(ssh, _options)
      ssh.shell.exec!('mongod --version').include? 'db version v3.2'
    end
  end
end
