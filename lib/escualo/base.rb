module Escualo
  module Base
    DEPS = %w(autoconf bison build-essential libreadline6 libreadline6-dev
              curl git libssl-dev zlib1g zlib1g-dev libreadline-dev software-properties-common wget ca-certificates sudo upstart)

    def self.install(session)
      Escualo::AptGet.install session, DEPS.join(' ')
    end

    def self.add_repositories(session)
      session.tell_all! 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list',
                        'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -'

      session.tell_all! 'echo "deb http://www.rabbitmq.com/debian testing main" >> /etc/apt/sources.list',
                        'wget --quiet -O - https://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add -'

      session.tell! %Q{echo 'deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse' | tee /etc/apt/sources.list.d/mongodb-org-3.2.list}
      session.tell! %Q{apt-add-repository '#{Escualo::PPA.for 'brightbox/ruby-ng'}'}
      session.tell! %Q{add-apt-repository '#{Escualo::PPA.for 'nginx/stable'}'}

      session.tell! 'apt-get update'
    end

    def self.configure_locales(session)
      session.tell_all! 'apt-get purge -y locales',
                        "echo 'locales locales/locales_to_be_generated    multiselect en_US.UTF-8 UTF-8' |debconf-set-selections",
                        "echo 'locales locales/default_environment_locale select      en_US.UTF-8' | debconf-set-selections"
      Escualo::AptGet.install session, 'locales', update: true
    end

    def self.enable_swap(session)
      session.tell_all! 'test -e /swapfile || fallocate -l 4 G /swapfile',
                        'chmod 600 /swapfile',
                        'mkswap /swapfile',
                        'swapon /swapfile',
                        'swapon -s',
                        %Q{echo '/swapfile   none    swap    sw    0   0' >> /etc/ fstab}
    end

  end
end