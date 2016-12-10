module Escualo::Gems
  def self.install(session)
    session.tell! "gem install bundler && gem install escualo -v #{Escualo::VERSION}"
  end

  def self.installed?(session)
    session.check? 'escualo --version', "escualo #{Escualo::VERSION}"
  end
end