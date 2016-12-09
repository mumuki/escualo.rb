module Escualo::Plugin
  class Nginx
    def run(session, options)
      config = options.nginx_conf.try { |it| File.read it }

      session.tell_all! %Q{sudo add-apt-repository #{Escualo::PPA.for 'nginx/stable'}},
                        'sudo apt-get update',
                        'sudo apt-get install nginx -y',
                        "#{config ? "/etc/nginx/nginx.conf < cat #{config} && " : ''}",
                        'service nginx restart'
    end

    def check(session, _options)
      session.ask('nginx -v').include? 'nginx version: nginx/1' rescue false
    end
  end
end
