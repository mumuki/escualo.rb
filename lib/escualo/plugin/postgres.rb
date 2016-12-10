module Escualo::Plugin
  class Postgres
    def run(session, options)
      pg_hba_conf = "/etc/postgresql/#{options.pg_version}/main/pg_hba.conf"

      # TODO move to base
      session.tell! 'apt-get install -y wget ca-certificates sudo'

      session.tell_all! 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list',
                        'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -'

      session.tell_all! 'apt-get update',
                        "apt-get install -y postgresql-#{options.pg_version} libpq-dev"

      session.tell_all! "echo 'local   all             postgres                                peer' > #{pg_hba_conf}",
                        "echo 'local   all             postgres                                peer' >> #{pg_hba_conf}",
                        "echo 'local   all             all                                     password' >> #{pg_hba_conf}",
                        "echo 'host    all             all             127.0.0.1/32            md5' >> #{pg_hba_conf}"

      session.tell_all! 'cd /',
                        %q{sudo -u postgres PGDATABASE='' psql "create role $POSTGRESQL_DB_USERNAME with createdb login password '$POSTGRESQL_DB_PASSWORD';"}
    end


    def check(session, options)
      session.ask('psql --version').include? "psql (PostgreSQL) #{options.pg_version}" rescue false
    end
  end
end