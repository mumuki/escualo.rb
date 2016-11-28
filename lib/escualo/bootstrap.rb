module Escualo
  module Bootstrap
    def self.install_base(ssh, options)
      ssh.shell.perform! %q{
        apt-get purge libruby* -y &&
        apt-get install software-properties-common -y &&
        apt-add-repository ppa:brightbox/ruby-ng &&
        apt-get update &&
        apt-get install -y \
                 autoconf \
                 bison \
                 build-essential \
                 libreadline6 \
                 libreadline6-dev \
                 curl \
                 git \
                 monit \
                 libssl-dev \
                 zlib1g \
                 zlib1g-dev \
                 libreadline-dev
      }, options
    end

    def self.install_ruby(ssh, options)
      if options.with_rbenv
        ssh.shell.perform! %q{
        curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash &&
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc &&
        echo 'eval "$(rbenv init -)"' >> ~/.bashrc
      }, options
      else
        ssh.shell.perform! %q{
        apt-get install -y \
                 ruby2.0 \
                 ruby2.0-dev
      }, options
      end
    end

    def self.enable_swap(ssh)
      ssh.exec! %q{ \
        test -e /swapfile ||
        fallocate -l 4G /swapfile && \
        chmod 600 /swapfile && \
        mkswap /swapfile && \
        swapon /swapfile && \
        swapon -s && \
        echo '/swapfile   none    swap    sw    0   0' >> /etc/fstab}
    end

    def self.setup_monit(ssh, options)
      ssh.perform! %Q{
        service monit stop
        cd /tmp &&
        wget https://mmonit.com/monit/dist/binary/5.16/monit-#{options.monit_version}-linux-x64.tar.gz &&
        tar -xzf monit-#{options.monit_version}-linux-x64.tar.gz &&
        cp monit-#{options.monit_version}/bin/monit /usr/bin/monit
        ln -s /etc/monit/monitrc /etc/monitrc
        service monit start
        echo 'set httpd port 2812 and' > /etc/monit/conf.d/web-server
        echo '  allow 0.0.0.0/0.0.0.0' >> /etc/monit/conf.d/web-server
        echo '  allow admin:#{options.monit_password}' >> /etc/monit/conf.d/web-server
        monit reload
    }, options
    end

    def self.install_gems(ssh, options)
      ssh.perform! 'gem install bundler && gem install escualo', options
    end
  end
end