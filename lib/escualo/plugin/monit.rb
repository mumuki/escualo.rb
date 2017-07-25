module Escualo::Plugin
  class Monit
    def run(session, options)
      Escualo::AptGet.install session, 'monit'

      session.tell_all! 'service monit stop',
                        'cd /tmp',
                        "wget https://mmonit.com/monit/dist/binary/5.16/monit-#{options.monit_version}-linux-x64.tar.gz",
                        "tar -xzf monit-#{options.monit_version}-linux-x64.tar.gz",
                        "cp monit-#{options.monit_version}/bin/monit /usr/bin/monit",
                        'rm -rf /etc/monitrc',
                        'ln -s /etc/monit/monitrc /etc/monitrc',
                        'service monit start',
                        "echo 'set httpd port 2812 and' > /etc/monit/conf.d/web-server",
                        "echo '  allow 0.0.0.0/0.0.0.0' >> /etc/monit/conf.d/web-server",
                        "echo '  allow admin:#{options.monit_password}' >> /etc/monit/conf.d/web-server",
                        "monit reload"
    end

    def installed?(session, options)
      session.tell!('monit --version').include? 'This is Monit version 5' rescue false
    end
  end
end
