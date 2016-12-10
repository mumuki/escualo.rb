module Escualo::Plugin
  class Docker
    def run(session, _options)
      session.tell! 'apt-get install -y docker.io'
    end

    def installed?(session, _options)
      session.check? 'docker -v', 'Docker version'
    end
  end
end