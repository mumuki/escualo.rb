module Escualo::Installers
  class Node
    def run(ssh, options)
      ssh.exec! %Q{
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | bash && \
        source ~/.bashrc && \
        nvm install 4.2.4
      }
    end
  end
end