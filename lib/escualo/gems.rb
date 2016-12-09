module Escualo::Gems
  def self.install(ssh, options)
    ssh.shell.perform! "gem install bundler && gem install escualo -v #{Escualo::VERSION}", options
  end

  def self.present?(ssh)
    ssh.shell.exec!('escualo --version').include? "escualo #{Escualo::VERSION}"
  end
end