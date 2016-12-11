# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = 'ubuntu/trusty64'

  (3000..3050).each do |it|
    config.vm.network 'forwarded_port', guest: it, host: it
  end

  config.vm.provider 'virtualbox' do |vb|
    vb.memory = '2048'
  end

  ssh_private_key_path = File.join Dir.home, '.ssh', 'id_rsa'
  ssh_public_key = File.readlines(File.join Dir.home, '.ssh', 'id_rsa.pub').first.strip

  if ARGV[0] == "ssh"
    config.ssh.username = 'root'
    config.ssh.private_key_path = ssh_private_key_path
  end

  ssh_public_key = File.readlines(File.join Dir.home, '.ssh', 'id_rsa.pub').first.strip
  config.vm.provision 'shell', inline: <<-SHELL
    mkdir -p /root/.ssh
    echo #{ssh_public_key} >> /root/.ssh/authorized_keys
  SHELL
end
