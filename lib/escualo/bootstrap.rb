module Escualo
  module Bootstrap
    def self.install_base(ssh)
      ssh.exec! %Q{ \
        apt-get install software-properties-common -y && \
        apt-add-repository ppa:brightbox/ruby-ng && \
        apt-get update && \
        apt-get install -y \
                 autoconf \
                 bison \
                 build-essential \
                 libreadline6 \
                 libreadline6-dev \
                 curl \
                 git \
                 libssl-dev \
                 ruby2.0 \
                 ruby2.0-dev \
                 zlib1g \
                 zlib1g-dev \
                 libreadline-dev }
    end

    def self.enable_swap(ssh)
      ssh.exec! %Q{ \
        test -e /swapfile ||
        fallocate -l 4G /swapfile && \
        chmod 600 /swapfile && \
        mkswap /swapfile && \
        swapon /swapfile && \
        swapon -s && \
        echo '/swapfile   none    swap    sw    0   0' >> /etc/fstab}
    end

    def self.setup_monit(ssh, options)
      ssh.exec! %Q{
        service monit stop && \
        cd /tmp && \
        wget https://mmonit.com/monit/dist/binary/5.16/monit-#{options.monit_version}-linux-x64.tar.gz && \
        tar -xzf monit-#{options.monit_version}-linux-x64.tar.gz && \
        cp monit-#{options.monit_version}/bin/monit /usr/bin/monit && \
        ln -s /etc/monit/monitrc /etc/monitrc && \
        service monit start && \
        'set httpd port 2812 and' > /etc/monit/conf.d/web-server && \
        '  allow 0.0.0.0/0.0.0.0' >> /etc/monit/conf.d/web-server && \
        '  allow admin:#{options.monit_password}' >> /etc/monit/conf.d/web-server && \
        monit reload}
    end

    def self.install_gems(ssh)
      ssh.exec! 'gem install bundler'
      ssh.exec! 'gem install escualo'
    end
  end
end