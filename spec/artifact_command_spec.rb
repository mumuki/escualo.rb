require 'spec_helper'

describe 'escualo artifact' do

  describe 'create' do
    let(:result) { dockerized_escualo 'artifact create service foo 80' }

    it { expect(result).to include  'RUN mkdir -p /var/scripts/foo'}
    it { expect(result).to include  'RUN chmod +x /var/scripts/foo/init' }
  end

  describe 'create' do
    let(:result) { dockerized_escualo 'artifact create site foo' }

    it { expect(result).to include  'RUN mkdir -p /var/scripts/foo'}
    it { expect(result).to include  'RUN chmod +x /var/scripts/foo/init' }
  end
end


