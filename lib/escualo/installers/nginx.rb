module Escualo::Installers
  class Nginx
    def run(ssh, options)
      config = File.read options.nginx_conf
      ssh.exec! %Q{
        sudo add-apt-repository ppa:nginx/stable && \
        sudo apt-get update && \
        sudo apt-get install nginx && \
                                      \
        /etc/nginx/nginx.conf < cat #{config} && \
        service nginx restart
      }
    end

    def check(ssh)
      ssh.exec!('nginx -v').to include '1.2.2'
    end
  end
end
