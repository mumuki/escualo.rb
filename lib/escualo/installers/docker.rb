module Escualo::Installers
  class Docker
    def run(ssh, options)
      ssh.exec! "apt-get install -y docker.io"
    end

    def check(ssh)
      ssh.exec!("docker -v").include? 'Docker version'
    end
  end
end