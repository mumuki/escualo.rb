module Escualo
  module Bootstrap
    def self.install_base(ssh, options)
      ssh.shell.perform! %q{
        apt-get purge libruby* -y &&
        apt-get install -y \
                 autoconf \
                 bison \
                 build-essential \
                 libreadline6 \
                 libreadline6-dev \
                 curl \
                 git \
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
        ssh.shell.perform! 'rbenv install 2.3.1 && rbenv global 2.3.1 && rbenv rehash', options
      else
        ssh.shell.perform! %Q{
        apt-get install software-properties-common -y &&
        apt-add-repository #{Escualo::PPA.for 'brightbox/ruby-ng'} &&
        apt-get update &&
        apt-get install -y ruby2.3 ruby2.3-dev
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

    def self.check(ssh)
      Escualo::Env.present?(ssh, :ESCUALO_BASE_VERSION) && Escualo::Gems.present?(ssh)
    end
  end
end