module Escualo::Plugin
  class Nginx
    def run(ssh, options)
      config = options.nginx_conf.try { |it| File.read it }

      ssh.perform! %Q{
        sudo add-apt-repository #{Escualo::PPA.for 'nginx/stable'} &&
        sudo apt-get update &&
        sudo apt-get install nginx -y &&
        #{config ? "/etc/nginx/nginx.conf < cat #{config} && " : ''}
        service nginx restart
      }, options
    end

    def check(ssh, _options)
      ssh.exec!('nginx -v').include? 'nginx version: nginx/1' rescue false
    end
  end
end
