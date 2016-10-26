require 'spec_helper'

describe 'escualo vars' do
 it { expect(Escualo::Vars.locale_variables).to eq "LANG" => "en_US.UTF-8",
                                                    "LC_ADDRESS" => "en_US.UTF-8",
                                                    "LC_ALL" => "en_US.UTF-8",
                                                    "LC_MEASUREMENT" => "en_US.UTF-8",
                                                    "LC_MONETARY" => "en_US.UTF-8",
                                                    "LC_NAME" => "en_US.UTF-8",
                                                    "LC_NUMERIC" => "en_US.UTF-8",
                                                    "LC_PAPER" => "en_US.UTF-8",
                                                    "LC_TELEPHONE" => "en_US.UTF-8" }
  it { expect(Escualo::Vars.production_variables).to eq "NODE_ENV" => "production",
                                                        "RACK_ENV" => "production",
                                                        "RAILS_ENV" => "production" }
  context 'on bootstraped env' do
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