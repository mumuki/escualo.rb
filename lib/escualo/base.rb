module Escualo
  module Base
    def self.install_base(ssh, options)
      ssh.shell.perform! %q{
        apt-get install -y \
                 autoconf \
                 bison \
                 build-essential \
                 libreadline6 \
                 libreadline6-dev \
                 curl \
                 git \
                 libssl-dev \
                 zlib1g \
                 zlib1g-dev \
                 libreadline-dev
      }, options
    end
  end
end