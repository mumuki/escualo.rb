module Escualo::Installers
  class Haskell
    def run(ssh, options)
      ssh.exec! "apt-get install -y haskell-platform"
    end
  end
end