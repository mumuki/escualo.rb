module Escualo::Installers
  class Rabbit
    def run(ssh, options)
      ssh.exec! %q{
        echo "deb http://www.rabbitmq.com/debian testing main" >> /etc/apt/sources.list && \
        wget https://www.rabbitmq.com/rabbitmq-signing-key-public.asc && \
        apt-key add rabbitmq-signing-key-public.asc && \
        apt-get update && \
        apt-get install rabbitmq-server && \
        rabbitmq-plugins enable rabbitmq_management
      }
      #TODO set username and password
    end

    def check(ssh)
      ssh.exec!("rabbitmq-server").include? 'ERROR: node with name "rabbit" already running'
    end
  end
end