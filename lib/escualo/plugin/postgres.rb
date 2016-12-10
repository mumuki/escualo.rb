module Escualo::Plugin
  class Postgres
    def run(session, options)
      raise 'missing pg-username' unless options.pg_username
      raise 'missing pg-password' unless options.pg_password

      pg_hba_conf = "/etc/postgresql/#{options.pg_version}/main/pg_hba.conf"

      session.tell_all! "apt-get install -y postgresql-#{options.pg_version} libpq-dev"

      session.tell_all! "echo 'local   all             postgres                                peer' > #{pg_hba_conf}",
                        "echo 'local   all             postgres                                peer' >> #{pg_hba_conf}",
                        "echo 'local   all             all                                     password' >> #{pg_hba_conf}",
                        "echo 'host    all             all             127.0.0.1/32            md5' >> #{pg_hba_conf}"

      session.tell_all! '/etc/init.d/postgresql restart',
                        'cd /',
                        "echo \"create role #{options.pg_username} with createdb login password '#{options.pg_password}';\" | sudo -u postgres PGDATABASE='' psql"
    end


    def check(session, options)
      session.ask('psql --version').include? "psql (PostgreSQL) #{options.pg_version}" rescue false
    end
  end
end