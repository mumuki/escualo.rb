require 'spec_helper'

describe 'install' do
  before { escualo 'bootstrap --monit-password sample' }

  describe 'docker' do
    context 'when installing by force' do
      it 'installs docker by force' do
        result = escualo 'install docker --force'

        expect($?).to eq 0
        expect(result).to include 'Installed successfully'
      end
    end
    context 'when already installed' do
      before { escualo 'install docker' }

      it 'installs docker by force' do
        result = escualo 'install docker'

        expect($?).to eq 0
        expect(result).to include 'docker is already installed'
      end
    end
  end

  describe 'haskell' do
    context 'when installing by force' do
      it 'installs haskell by force' do
        result = escualo 'install haskell --force'

        expect($?).to eq 0
        expect(result).to include 'Installed successfully'
      end
    end
    context 'when already installed' do
      before { escualo 'install haskell' }

      it 'installs haskell by force' do
        result = escualo 'install haskell'

        expect($?).to eq 0
        expect(result).to include 'haskell is already installed'
      end
    end
  end

  describe 'mongo' do
    context 'when installing by force' do
      it 'installs mongo by force' do
        result = escualo 'install mongo --force'

        expect($?).to eq 0
        expect(result).to include 'Installed successfully'
      end
    end
    context 'when already installed' do
      before { escualo 'install mongo' }

      it 'installs mongo by force' do
        result = escualo 'install mongo'

        expect($?).to eq 0
        expect(result).to include 'mongo is already installed'
      end
    end
  end

  describe 'nginx' do
    context 'when installing by force' do
      it 'installs nginx by force' do
        result = escualo 'install nginx --force'

        expect($?).to eq 0
        expect(result).to include 'Installed successfully'
      end
    end
    context 'when already installed' do
      before { escualo 'install nginx' }

      it 'installs nginx by force' do
        result = escualo 'install nginx'

        expect($?).to eq 0
        expect(result).to include 'nginx is already installed'
      end
    end
  end

  describe 'node' do
    context 'when installing by force' do
      it 'installs node by force' do
        result = escualo 'install node --force'

        expect($?).to eq 0
        expect(result).to include 'Installed successfully'
      end
    end
    context 'when already installed' do
      before { escualo 'install node' }

      it 'installs node by force' do
        result = escualo 'install node'

        expect($?).to eq 0
        expect(result).to include 'node is already installed'
      end
    end
  end

  describe 'postgre' do
    context 'when installing by force' do
      it 'installs postgre by force' do
        result = escualo 'install postgre --force'

        expect($?).to eq 0
        expect(result).to include 'Installed successfully'
      end
    end
    context 'when already installed' do
      before { escualo 'install postgre' }

      it 'installs postgre by force' do
        result = escualo 'install postgre'

        expect($?).to eq 0
        expect(result).to include 'postgre is already installed'
      end
    end
  end

  describe 'rabbit' do
    context 'when installing by force' do
      it 'installs rabbit by force' do
        result = escualo 'install rabbit --rabbit-admin-password 12345678 --force'

        expect($?).to eq 0
        expect(result).to include 'Installed successfully'
      end
    end
    context 'when already installed' do
      before { escualo 'install rabbit --rabbit-admin-password 12345678' }

      it 'installs rabbit by force' do
        result = escualo 'install rabbit --rabbit-admin-password 12345678'

        expect($?).to eq 0
        expect(result).to include 'rabbit is already installed'
      end
    end
  end
end