module Escualo
  module Base
    DEPS = %w(autoconf bison build-essential libreadline6 libreadline6-dev
              curl git libssl-dev zlib1g zlib1g-dev libreadline-dev software-properties-common)

    def self.install_base(session)
      session.tell! "apt-get install -y #{DEPS.join(' ')}"
    end
  end
end