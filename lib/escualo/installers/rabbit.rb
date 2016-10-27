module Escualo::Installers
  class Rabbit
    def run(ssh, options)
      raise 'missing rabbit password' unless options.rabbit_admin_password

      ssh.shell.perform! %Q{
        echo "deb http://www.rabbitmq.com/debian testing main" >> /etc/apt/sources.list && \
        wget https://www.rabbitmq.com/rabbitmq-signing-key-public.asc && \
        apt-key add rabbitmq-signing-key-public.asc && \
        apt-get update && \
        apt-get install rabbitmq-server -y --force-yes && \
        rabbitmq-plugins enable rabbitmq_management && \
        rabbitmqctl add_user admin #{options.rabbit_admin_password} && \
        rabbitmqctl set_user_tags admin administrator
      }, options
    end

    def check(ssh)
      ssh.exec!('rabbitmq-server').include? 'node with name "rabbit" already running'
    end
  end
end

