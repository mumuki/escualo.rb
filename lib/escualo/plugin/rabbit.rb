module Escualo::Plugin
  class Rabbit
    def run(session, options)
      raise 'missing rabbit-admin-password' unless options.rabbit_admin_password

      Escualo::AptGet.install session, 'rabbitmq-server'

      session.tell_all! 'rabbitmq-plugins enable rabbitmq_management',
                        "rabbitmqctl add_user admin #{options.rabbit_admin_password}",
                        'rabbitmqctl set_user_tags admin administrator'
    end

    def installed?(session, _options)
      session.check? 'rabbitmq-server', 'node with name "rabbit" already running'
    end
  end
end

