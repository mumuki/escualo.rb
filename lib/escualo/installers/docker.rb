module Escualo::Installers
  class Docker
    def run(ssh, options)
      ssh.exec! "apt-get install -y docker.io"
    end
  end
end