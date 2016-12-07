module Escualo::PPA
  def self.for(name)
    "deb http://ppa.launchpad.net/#{name}/ubuntu trusty main"
  end
end