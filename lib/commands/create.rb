command 'create service' do |c|
  c.syntax = 'escualo create service <NAME> <PORT>'
  c.description = 'Setup a micro-service deployment'
  c.ssh_action do |args, options, ssh|
    name = args.first
    port = args.second

    launch_command = "exec bundle exec rackup -o 0.0.0.0 -p #{port} > rack.log"
    install_command="bundle install --without development test";

    #creating init scripts
    ssh.exec! "mkdir -p /var/scripts/#{name}"
    ssh.upload_template! "/var/scripts/#{name}/codechange", "codechange.sh", name: name
    ssh.exec! "chmod +x /var/scripts/#{name}/codechange"

    ssh.upload_template! "/var/scripts/#{name}/init",
                         "init.sh",
                         name: name,
                         install_command: install_command
    ssh.exec! "chmod +x /var/scripts/#{name}/init"

    #configuring upstart
    ssh.upload_template "/etc/init/#{name}.conf",
                        "upstart.conf",
                        name: name,
                        launch_command: launch_command

    #configuring monit
    ssh.upload_template! "/etc/monit/conf.d/escualo-#{name}", "monit.conf", name: name
    ssh.exec! "monit reload"

    #create remote push infrastructure
    ssh.exec! %Q{\
      cd /var && \
      mkdir -p www && \
      mkdir -p repo && \
      cd repo && \
      rm -rf $SERVICE.git && \
      mkdir $SERVICE.git && \
      cd $SERVICE.git && \
      git init --bare
    }
    ssh.upload_template! "/var/repo/#{name}.git/hooks/post-receive", "post-receive.sh", name: name
    ssh.exec! "chmod +x post-receive"
  end
end

command 'create site' do |c|
  c.syntax = 'escualo create site'
  c.description = 'Setup an static site deployment'
  c.action do |args, options|
    say "...."
  end
end

command 'create executable' do |c|
  c.syntax = 'escualo create executable'
  c.description = 'Setup an executable command deployment'
  c.action do |args, options|
    say "...."
  end
end
