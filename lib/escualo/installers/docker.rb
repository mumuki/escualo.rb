module Escualo::Installers
  class Docker
    def run(ssh, options)
      ssh.perform! 'apt-get install -y docker.io', options
    end

    def check(ssh)
      ssh.exec!('docker -v').include? 'Docker version'
    end
  end
end