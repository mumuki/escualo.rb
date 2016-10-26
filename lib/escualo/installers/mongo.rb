module Escualo::Installers
  class Mongo
    def run(ssh, options)
      ssh.exec! %Q{
        echo 'deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list && \
        apt-get update && \
        apt-get install -y --force-yes mongodb-org && \
        echo '' >> /etc/init/mongodb && \
        echo 'respawn' >> /etc/init/mongodb
      }
    end

    def check(ssh)
      ssh.exec!("mongod --version").start_with? 'db version v3.2'
    end
  end
end
