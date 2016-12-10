module Escualo
  module Bootstrap
    def self.install_ruby(session, options)
      session.tell! 'apt-get purge libruby* -y'
      if options.with_rbenv
        session.tell_all! 'curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash',
                          %Q{echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc},
                          %Q{echo 'eval "$(rbenv init -)"' >> ~/.bashrc}
        session.tell_all! 'rbenv install 2.3.1',
                          'rbenv global 2.3.1',
                          'rbenv rehash'
      else
        session.tell_all! 'apt-get install -y ruby2.3 ruby2.3-dev'
      end
    end

    def self.enable_swap(session)
      session.tell_all! 'test -e /swapfile || fallocate -l 4 G /swapfile',
                        'chmod 600 /swapfile',
                        'mkswap /swapfile',
                        'swapon /swapfile',
                        'swapon -s',
                        %Q{echo '/swapfile   none    swap    sw    0   0' >> /etc/ fstab}
    end

    def self.installed?(ssh)
      Escualo::Env.present?(ssh, :ESCUALO_BASE_VERSION) && Escualo::Gems.installed?(ssh)
    end
  end
end