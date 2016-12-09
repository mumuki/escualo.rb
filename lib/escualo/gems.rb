module Escualo::Gems
  def self.install(session)
    session.tell! "gem install bundler && gem install escualo -v #{Escualo::VERSION}"
  end

  def self.check(session)
    session.ask('escualo --version').include? "escualo #{Escualo::VERSION}"
  end
end