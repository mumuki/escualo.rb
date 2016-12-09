module Escualo::Plugin
  class Postgre
    def run(ssh, options)
      pg_hba_conf = "/etc/postgresql/#{options.pg_version}/main/pg_hba.conf"

      ssh.shell.perform! %Q{
        apt-get install postgresql libpq-dev -y &&
        echo 'local   all             postgres                                peer' > #{pg_hba_conf} &&
        echo 'local   all             postgres                                peer' >> #{pg_hba_conf} &&
        echo 'local   all             all                                     password' >> #{pg_hba_conf} &&
        echo 'host    all             all             127.0.0.1/32            md5' >> #{pg_hba_conf} &&
        cd / &&
        sudo -u postgres PGDATABASE='' psql <<EOF
        create role $POSTGRESQL_DB_USERNAME with createdb login password '$POSTGRESQL_DB_PASSWORD';
EOF
      }, options
    end

    def check(ssh, options)
      ssh.shell.exec!('psql --version').include? "psql (PostgreSQL) #{options.pg_version}" rescue false
    end
  end
end