module Escualo::Plugin
  class Node
    def run(session, _options)
      session.tell! %Q{
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | bash && \
        source ~/.bashrc &&
        nvm install 4.2.4
      }
    end

    def check(session, _options)
      session.tell!('nvm use node').include? 'Now using node v4.2.4' rescue false
    end
  end
end