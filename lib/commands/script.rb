module Escualo::Script
  class Mode
    def run_commands_for!(script, extra='', ssh, options)
      Escualo::Script.each_command script, extra do |command|
        run_command! command, ssh, options
      end
    end
  end
end

class Escualo::Script::Standard < Escualo::Script::Mode
  def start!
  end
  def run_command!(command, ssh, options)
    ssh.shell.perform! command, options
  end
end

class Escualo::Script::Dockerized < Escualo::Script::Mode
  def start!
    open('Dockerfile', 'w') do |f|
      f.puts "
FROM ubuntu
MAINTAINER #{ENV['USER']}
RUN apt-get update && apt-get install ruby ruby-dev build-essential -y
RUN gem install escualo
"
    end
  end

  def run_command!(command, ssh, options)
    open('Dockerfile', 'a') { |f| f << "RUN #{command}\n" }
  end
end

command 'script' do |c|
  c.syntax = 'escualo script <FILE>'
  c.description = 'Runs a escualo configuration'
  c.option '--dockerized', TrueClass, 'Create a Dockerfile instead of running commands'

  c.action do |args, options|
    if options.dockerized
      mode = Escualo::Script::Dockerized.new
    else
      mode = Escualo::Script::Standard.new
    end

    mode.start!
    file = YAML.load_file args.first
    local_ssh = Net::SSH::Connection::LocalSession.new
    delegated_options = Escualo::Script.delegated_options options

    step 'Running local commands...' do
      mode.run_commands_for! file['local'], delegated_options, local_ssh, options
    end

    step 'Running remote commands...' do
      Net::SSH.with_session(ssh_session_options) do |ssh|
        mode.run_commands_for! file['remote'], ssh, options
      end
    end

    step 'Running deploy commands...' do
      mode.run_commands_for! file['deploy'], delegated_options, local_ssh, options
    end
  end
end