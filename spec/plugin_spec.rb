require 'spec_helper'

describe 'escualo plugin' do

  describe 'install postgres' do
    let(:result) { dockerized_escualo 'plugin install postgres' }

    it { expect(result).to include  'RUN apt-get install postgresql libpq-dev'}
    it { expect(result).to include  'create role $POSTGRESQL_DB_USERNAME'}
  end

  describe 'install monit' do
    let(:result) { dockerized_escualo 'plugin install monit' }

    it { expect(result).to include  'RUN mkdir -p /var/scripts/foo'}
  end

  describe 'install rabbit' do
    let(:result) { dockerized_escualo 'plugin install rabbit --rabit-admin-password 12345678' }

    it { expect(result).to include  'RUN mkdir -p /var/scripts/foo'}
  end

  describe 'install mongo' do
    let(:result) { dockerized_escualo 'plugin install mongo' }

    it { expect(result).to include  'RUN mkdir -p /var/scripts/foo'}
  end

end


