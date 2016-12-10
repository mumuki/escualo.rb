module Escualo::Plugin
  class Haskell
    def run(session, _options)
      Escualo::AptGet.install session, 'haskell-platform'
    end

    def installed?(session, _options)
      session.check? 'ghc --version', 'The Glorious Glasgow Haskell Compilation System'
    end
  end
end