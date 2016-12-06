module Escualo::Plugin
  class Node
    def run(ssh, options)
      ssh.shell.perform! %Q{
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | bash && \
        source ~/.bashrc && \
        nvm install 4.2.4
      }, options
    end

    def check(ssh, _options)
      ssh.shell.exec!('nvm use node').include? 'Now using node v4.2.4'
    end
  end
end