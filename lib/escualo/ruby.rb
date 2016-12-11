module Escualo
  module Ruby
    def self.install(session, options)
      session.tell! 'apt-get purge libruby* -y'
      if options.with_rbenv
        session.tell_all! 'curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash',
                          %Q{echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc},
                          %Q{echo 'eval "$(rbenv init -)"' >> ~/.bashrc}
        session.tell_all! 'rbenv install 2.3.1',
                          'rbenv global 2.3.1',
                          'rbenv rehash'
      else
        Escualo::AptGet.install session, 'ruby2.3 ruby2.3-dev'
      end
    end
  end
end