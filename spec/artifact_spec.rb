require 'spec_helper'

describe 'escualo artifact create' do
  before do
    escualo('artifact list').split.each do |it|
      escualo "artifact destroy #{it}"
    end
  end

  describe 'create service' do
    it 'can create service' do
      result = escualo 'artifact create service atheneum 80'
      expect($?).to eq 0

      expect(result).to include 'Service atheneum created successfully'
      expect(result).to include 'Now you can deploy this service'

      expect(escualo 'artifact list').to include 'atheneum'
    end

    context 'when already created' do
      before { escualo 'artifact create service atheneum 80' }

      it do
        result = escualo 'artifact create service atheneum 80'
        expect(result).to include 'Use --force to proceed it anyway'
        expect(result).to include 'Nothing to do'
      end
    end
  end

  describe 'create executable' do
    it 'can create executable' do
      result = escualo 'artifact create executable mulang'
      expect($?).to eq 0
      expect(result).to include 'Executable mulang created successfully'
      expect(result).to include 'Now you can deploy this executable'

      expect(escualo 'artifact list').to include 'mulang'
    end

    context 'when already created' do
      before { escualo 'artifact create executable mulang' }

      it do
        result = escualo 'artifact create executable mulang'
        expect(result).to include 'Use --force to proceed it anyway'
        expect(result).to include 'Nothing to do'
      end
    end
  end

  describe 'create site' do
    it 'can create site' do
      result = escualo 'artifact create site editor'
      expect($?).to eq 0
      expect(result).to include 'Site editor created successfully'
      expect(result).to include 'Now you can deploy this site'

      expect(escualo 'artifact list').to include 'editor'
    end

    context 'when already created' do
      before { escualo 'artifact create site editor' }

      it do
        result = escualo 'artifact create site editor'
        expect(result).to include 'Use --force to proceed it anyway'
        expect(result).to include 'Nothing to do'
      end
    end
  end

  it 'can destroy artifact' do
    escualo 'artifact create service zaraza 80'
    escualo 'artifact destroy zaraza'

    expect(escualo 'artifact list').to_not include 'zaraza'
  end
end


