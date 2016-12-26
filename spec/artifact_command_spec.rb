require 'spec_helper'

describe 'escualo artifact' do

  describe 'create service' do
    context 'when all args passed' do
      let(:result) { dockerized_escualo 'artifact create service foo 80' }

      it { expect(result).to include  'RUN mkdir -p /var/scripts/foo'}
      it { expect(result).to include  'RUN chmod +x /var/scripts/foo/init' }
    end

    context 'when less args passed' do
      it { expect { dockerized_escualo 'artifact create service foo' }.to raise_error RuntimeError }
    end
  end

  describe 'destroy' do
    let(:result) { dockerized_escualo 'artifact destroy foo' }

    it { expect(result).to include  'rm -rf /var/www/foo' }
    it { expect(result).to include  'rm -rf /var/repo/foo.git' }
  end

  describe 'create site' do
    let(:result) { dockerized_escualo 'artifact create site foo' }

    it { expect(result).to include  'RUN mkdir -p /var/scripts/foo'}
    it { expect(result).to include  'RUN chmod +x /var/scripts/foo/init' }
  end
end


