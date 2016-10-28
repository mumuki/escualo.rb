module Escualo
  module Artifacts
    def self.create_scripts_dir(ssh, name)
      ssh.exec! "mkdir -p /var/scripts/#{name}"
    end

    def self.create_init_script(ssh, options)
      ssh.upload_template! "/var/scripts/#{options[:name]}/init",
                           'init.sh',
                           options
      ssh.exec! "chmod +x /var/scripts/#{options[:name]}/init"
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
      ssh.upload_template! "/var/repo/#{name}.git/hooks/post-receive", 'post-receive.sh', options
      ssh.exec! 'chmod +x post-receive'
    end

    def self.configure_monit(ssh, name)
      ssh.exec! 'mkdir -p /etc/monit/conf.d/'
      ssh.upload_template! "/etc/monit/conf.d/escualo-#{name}", 'monit.conf', name: name
      ssh.exec! 'monit reload'
    end

    def self.create_codechange_script(ssh, name)
      ssh.upload_template! "/var/scripts/#{name}/codechange", "codechange.sh", name: name
      ssh.exec! "chmod +x /var/scripts/#{name}/codechange"
    end

    def self.configure_upstart(ssh, options)
      ssh.upload_template! "/etc/init/#{name}.conf", 'upstart.conf', options
    end
  end
end
