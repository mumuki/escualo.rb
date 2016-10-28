module Escualo::Plugin
  class Haskell
    def run(ssh, options)
      ssh.perform! 'apt-get install -y haskell-platform', options
    end

    def check(ssh)
      ssh.exec!('ghc --version').include? 'The Glorious Glasgow Haskell Compilation System'
    end
  end
end