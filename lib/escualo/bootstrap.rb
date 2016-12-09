module Escualo
  module Bootstrap
    def self.install_ruby(session, options)
      session.tell! 'apt-get purge libruby* -y'
      if options.with_rbenv
        session.tell! %q{
          curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash &&
          echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc &&
          echo 'eval "$(rbenv init -)"' >> ~/.bashrc
        }
        session.tell! 'rbenv install 2.3.1 && rbenv global 2.3.1 && rbenv rehash'
      else
        session.tell! %Q{apt-add-repository '#{Escualo::PPA.for 'brightbox/ruby-ng'}' &&
        apt-get update &&
        apt-get install -y ruby2.3 ruby2.3-dev
      }
      end
    end

    def self.enable_swap(session)
      session.tell! %q{ \
        test -e /swapfile ||
        fallocate -l 4G /swapfile && \
        chmod 600 /swapfile && \
        mkswap /swapfile && \
        swapon /swapfile && \
        swapon -s && \
        echo '/swapfile   none    swap    sw    0   0' >> /etc/fstab}
    end

    def self.check(ssh)
      Escualo::Env.present?(ssh, :ESCUALO_BASE_VERSION) && Escualo::Gems.check(ssh)
    end
  end
end