require 'spec_helper'

describe 'integration' do
  context 'on not bootstrapped host' do
    it 'can force bootstrap' do
      escualo "bootstrap --monit-password sample --force "

      expect($?).to eq 0
    end
  end

  context "on bootstrapped host" do
    before { escualo "bootstrap --monit-password sample" }

    describe "vars" do
      before { escualo "vars clean" }

      it "can list vars" do
        result = escualo "vars list"

        expect($?).to eq 0
        expect(result).to include 'LANG=en_US.UTF-8'
        expect(result).to include 'RACK_ENV=production'
        expect(result).to include 'ESCUALO_BASE_VERSION'
        expect(result).to_not include 'FOO'
      end

      it "can set vars" do
        escualo "vars set FOO=BAR"
        result = escualo "vars list"

        expect($?).to eq 0
        expect(result).to include 'FOO=BAR'
      end

      it "can unset vars" do
        escualo "vars set FOO=BAR"
        escualo "vars set BAZ=GOO"
        escualo "vars set BAZINGA=ZAZ"

        escualo "vars unset BAZINGA BAZ"

        result = escualo "vars list"

        expect($?).to eq 0
        expect(result).to include 'FOO'
        expect(result).to_not include 'BAZ'
        expect(result).to_not include 'BAZINGA'
      end
    end
  end
end


