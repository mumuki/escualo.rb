module Escualo
  module Artifact
    def self.setup(ssh)
      ssh.exec! %q{
        mkdir -p/var/repo/ && \
        mkdir -p /var/scripts/
    }
    end

    def self.destroy(ssh, name)
      raise 'name must not be blank' if name.blank?
      raise 'name must not contains wildcards' if name.include?('*')

      ssh.exec! "rm -rf /var/scripts/#{name}"
      ssh.exec! "rm -rf /var/repo/#{name}.git"
      ssh.exec! "rm -f /etc/monit/conf.d/escualo-#{name}"
      ssh.exec! "rm -f /etc/init/#{name}.conf"
    end

    def self.present?(ssh, name)
      list(ssh).include? name
    end

    def self.create_scripts_dir(ssh, name)
      ssh.exec! "mkdir -p /var/scripts/#{name}"
    end

    def self.create_init_script(ssh, options)
      ssh.upload_template! "/var/scripts/#{options[:name]}/init",
                           'init.sh',
                           options
      ssh.exec! "chmod +x /var/scripts/#{options[:name]}/init"
    end

    def self.list(ssh)
      ssh.exec!('ls /var/repo/').captures(/(.*)\.git/).map { $1 }
    end

    def self.create_push_infra(ssh, options)
      name = options[:name]
      ssh.exec! %Q{\
        cd /var && \
        mkdir -p www && \
        mkdir -p repo && \
        cd repo && \
        rm -rf #{name}.git && \
        mkdir #{name}.git && \
        cd #{name}.git && \
        git init --bare
      }
      hook_file = "/var/repo/#{name}.git/hooks/post-receive"
      ssh.upload_template! hook_file, 'post-receive.sh', options
      ssh.exec! "chmod +x #{hook_file}"
    end

    def self.configure_monit(ssh, name)
      ssh.exec! 'mkdir -p /etc/monit/conf.d/'
      ssh.upload_template! "/etc/monit/conf.d/escualo-#{name}", 'monit.conf', name: name
      ssh.exec! 'monit reload'
    end

    def self.create_codechange_script(ssh, name)
      ssh.upload_template! "/var/scripts/#{name}/codechange", 'codechange.sh', name: name
      ssh.exec! "chmod +x /var/scripts/#{name}/codechange"
    end

    def self.configure_upstart(ssh, options)
      ssh.upload_template! "/etc/init/#{options[:name]}.conf", 'upstart.conf', options
    end
  end
end
