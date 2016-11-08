module Escualo::Plugin
  class Postgre
    def run(ssh, options)
      pg_hba_conf = '/etc/postgresql/9.3/main/pg_hba.conf'

      ssh.shell.perform! %Q{
        apt-get install postgresql libpq-dev -y &&
        echo 'local   all             postgres                                peer' > #{pg_hba_conf} && \
        echo 'local   all             postgres                                peer' >> #{pg_hba_conf} && \
        echo 'local   all             all                                     password' >> #{pg_hba_conf} && \
        echo 'host    all             all             127.0.0.1/32            md5' >> #{pg_hba_conf}
      }, options
    end

    def check(ssh)
      ssh.shell.exec!('psql').include? 'FATAL:  role "root" does not exist'
    end
  end
end