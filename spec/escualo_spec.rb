require 'spec_helper'

def escualo(args)
  options = '--hostname 127.0.0.1 ' +
            '--username vagrant ' +
            '--ssh-port 2222 ' +
            '--ssh-key .vagrant/machines/default/virtualbox/private_key'
  %x{./bin/escualo #{args} #{options}}
end

describe Escualo do

  describe "version" do
    it { expect(escualo "--version").to eq "escualo 0.0.1\n" }
  end

  describe "vars" do
    before { escualo "vars clean" }

    it "can list vars" do
      escualo "vars list"
      expect($?).to eq 0
    end

     it "can set vars" do
      escualo "vars set FOO=BAR"
      result = escualo "vars list"

      expect(result).to include 'FOO=BAR'
    end
  end
end
