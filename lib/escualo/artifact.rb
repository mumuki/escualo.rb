module Escualo
  module Artifact
    def self.setup(session)
      session.tell_all! 'mkdir -p /var/repo/',
                        'mkdir -p /var/scripts/'
    end

    def self.destroy(session, name)
      raise 'name must not be blank' if name.blank?
      raise 'name must not contains wildcards' if name.include?('*')

      session.tell_all! "rm -rf /var/scripts/#{name}",
                        "rm -rf /var/repo/#{name}.git",
                        "rm -rf /var/www/#{name}",
                        "rm -f /etc/monit/conf.d/escualo-#{name}",
                        "rm -f /etc/init/#{name}.conf",
                        "test ! -e /var/repo/#{name}.git"
    end

    def self.present?(session, name)
      list(session).include? name rescue false
    end

    def self.create_scripts_dir(session, name)
      session.tell! "mkdir -p /var/scripts/#{name}"
    end

    def self.create_init_script(session, options)
      session.upload_template! "/var/scripts/#{options[:name]}/init",
                               'init.sh',
                               options
      session.tell! "chmod +x /var/scripts/#{options[:name]}/init"
    end

    def self.list(session)
      session.ask('ls /var/repo/').captures(/(.*)\.git/).map { $1 }
    end

    def self.create_push_infra(session, options)
      name = options[:name]
      session.tell_all! 'cd /var',
                        'mkdir -p www',
                        'mkdir -p repo',
                        'cd repo',
                        "rm -rf #{name}.git",
                        "mkdir #{name}.git",
                        "cd #{name}.git",
                        'git init --bare'
      hook_file = "/var/repo/#{name}.git/hooks/post-receive"
      session.upload_template! hook_file, 'post-receive.sh', options
      session.tell! "chmod +x #{hook_file}"
    end

    def self.configure_monit(session, options)
      name = options[:name]
      session.tell! 'mkdir -p /etc/monit/conf.d/'
      session.upload_template! "/etc/monit/conf.d/escualo-#{name}", 'monit.conf', options
      session.tell! 'monit reload'
    end

    def self.create_codechange_script(session, name)
      session.upload_template! "/var/scripts/#{name}/codechange", 'codechange.sh', name: name
      session.tell! "chmod +x /var/scripts/#{name}/codechange"
    end

    def self.configure_upstart(session, options)
      session.upload_template! "/etc/init/#{options[:name]}.conf", 'upstart.conf', options
    end
  end
end
