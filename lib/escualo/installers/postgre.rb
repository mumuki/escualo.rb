module Escualo::Installers
  class Postgre
    def run(ssh, options)
      pg_hba_conf = "/etc/postgresql/9.3/main/pg_hba.conf"

      ssh.exec! %Q{
        apt-get install curl git postgresql libpq-dev

        echo 'local   all             postgres                                peer' > #{pg_hba_conf}
        echo 'local   all             postgres                                peer' >> #{pg_hba_conf}
        echo 'local   all             all                                     password' >> #{pg_hba_conf}
        echo 'host    all             all             127.0.0.1/32            md5' >> #{pg_hba_conf}"
      }
    end
  end
end