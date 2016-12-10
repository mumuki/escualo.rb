module Escualo
  module Base
    DEPS = %w(autoconf bison build-essential libreadline6 libreadline6-dev
              curl git libssl-dev zlib1g zlib1g-dev libreadline-dev software-properties-common wget ca-certificates sudo upstart locales)

    def self.install_base(session)
      session.tell! "apt-get update && apt-get install -y #{DEPS.join(' ')}"

      session.tell_all! 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list',
                        'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -'

      session.tell_all! 'echo "deb http://www.rabbitmq.com/debian testing main" >> /etc/apt/sources.list',
                        'wget --quiet -O - https://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add -'

      session.tell! %Q{echo 'deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse' | tee /etc/apt/sources.list.d/mongodb-org-3.2.list}
      session.tell! %Q{apt-add-repository '#{Escualo::PPA.for 'brightbox/ruby-ng'}'}
      session.tell! %Q{add-apt-repository '#{Escualo::PPA.for 'nginx/stable'}'}

      session.tell! 'apt-get update'
    end
  end
end