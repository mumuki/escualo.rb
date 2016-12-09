module Escualo::Plugin
  class Docker
    def run(session, _options)
      session.tell! 'apt-get install -y docker.io'
    end

    def check(session, _options)
      session.ask('docker -v').include? 'Docker version' rescue false
    end
  end
end