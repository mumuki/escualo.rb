module Escualo::Plugin
  class Rabbit
    def run(session, options)
      raise 'missing rabbit-admin-password' unless options.rabbit_admin_password
      session.tell_all! 'apt-get install rabbitmq-server -y --force-yes',
                        'rabbitmq-plugins enable rabbitmq_management',
                        "rabbitmqctl add_user admin #{options.rabbit_admin_password}",
                        'rabbitmqctl set_user_tags admin administrator'
    end

    def check(session, _options)
      session.ask('rabbitmq-server').include? 'node with name "rabbit" already running' rescue false
    end
  end
end

