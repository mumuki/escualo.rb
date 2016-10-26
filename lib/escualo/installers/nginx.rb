module Escualo::Installers
  class Nginx
    def run(ssh, options)
      config = File.read options.nginx_conf
      ssh.exec! %Q{
        sudo add-apt-repository ppa:nginx/stable && \
        sudo apt-get update && \
        sudo apt-get install nginx
      }
      ssh.exec! "/etc/nginx/nginx.conf < cat #{config}"
      ssh.exec! "service nginx restart"
    end
  end
end
