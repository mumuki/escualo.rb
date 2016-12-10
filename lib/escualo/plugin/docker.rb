module Escualo::Plugin
  class Docker
    def run(session, _options)
      Escualo::AptGet.install session, 'docker.io'
    end

    def installed?(session, _options)
      session.check? 'docker -v', 'Docker version'
    end
  end
end