require 'spec_helper'

describe 'escualo env', if: vagrant_up do
  context 'on bootstraped env' do
    before { escualo 'bootstrap --monit-password sample' }

    describe 'env' do
      before { escualo 'env clean' }

      it 'can list env' do
        result = escualo 'env list'

        expect($?).to eq 0
        expect(result).to include 'LANG=en_US.UTF-8'
        expect(result).to include 'RACK_ENV=production'
        expect(result).to include 'ESCUALO_BASE_VERSION'
        expect(result).to_not include 'FOO'
      end

      it 'can set env' do
        escualo 'env set FOO=BAR'
        result = escualo 'env list'

        expect($?).to eq 0
        expect(result).to include 'FOO=BAR'
      end

      it 'can unset env' do
        escualo 'env set FOO=BAR'
        escualo 'env set BAZ=GOO'
        escualo 'env set BAZINGA=ZAZ'

        escualo 'env unset BAZINGA BAZ'

        result = escualo 'env list'

        expect($?).to eq 0
        expect(result).to include 'FOO'
        expect(result).to_not include 'BAZ'
        expect(result).to_not include 'BAZINGA'
      end
    end
  end
end