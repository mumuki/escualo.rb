module Escualo::Installers
  class Haskell
    def run(ssh, options)
      ssh.exec! "apt-get install -y haskell-platform"
    end

    def check(ssh)
      ssh.exec!("ghc --version").include? 'The Glorious Glasgow Haskell Compilation System'
    end
  end
end