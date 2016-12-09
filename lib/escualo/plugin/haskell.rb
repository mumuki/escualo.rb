module Escualo::Plugin
  class Haskell
    def run(session, _options)
      session.tell! 'apt-get install -y haskell-platform'
    end

    def check(session, _options)
      session.ask('ghc --version').include? 'The Glorious Glasgow Haskell Compilation System' rescue false
    end
  end
end