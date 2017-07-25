require 'spec_helper'

describe 'escualo plugin' do

  describe 'install postgres' do
    context 'missing arguments' do
      it { expect { logonly_escualo 'plugin install postgres' }.to raise_error(RuntimeError) }
    end

    context 'server mode' do
      let(:result) { logonly_escualo 'plugin install postgres --pg-username foo --pg-password abcdefg' }

      it { expect(result).to include 'apt-get install -y --force-yes postgresql-9.3 libpq-dev' }
      it { expect(result).to include "create role foo with createdb login password 'abcdefg';" }
      it { expect(result).to include '> /etc/postgresql/9.3/main/pg_hba.conf' }
      it { expect(result).to_not include 'echo "deb http://apt.postgresql.org/pub/repos/apt/' }
    end

    context 'client mode' do
      let(:result) { logonly_escualo 'plugin install postgres --pg-libs-only' }

      it { expect(result).to include 'apt-get install -y --force-yes postgresql-client-9.3 libpq-dev' }
      it { expect(result).to_not include "create role" }
    end
  end

  describe 'install postgres --pg-libs-only' do
    let(:result) { logonly_escualo 'plugin install postgres --pg-username foo --pg-password abcdefg --pg-libs-only' }
    it { expect(result).to start_with 'apt-get install -y --force-yes postgresql-client-9.3 libpq-dev' }
  end

  describe 'install monit' do
    let(:result) { logonly_escualo 'plugin install monit --monit-password foo' }

    it { expect(result).to start_with 'apt-get install -y --force-yes monit' }
    it { expect(result).to include 'service monit stop' }
    it { expect(result).to include 'monit reload' }
  end

  describe 'install rabbit' do
    let(:result) { logonly_escualo 'plugin install rabbit --rabbit-admin-password 12345678' }

    it { expect(result).to include "apt-get install -y --force-yes rabbitmq-server" }
    it { expect(result).to include "rabbitmq-plugins enable rabbitmq_management" }
  end

  describe 'install mongo' do
    let(:result) { logonly_escualo 'plugin install mongo' }

    it { expect(result).to start_with "apt-get install -y --force-yes mongodb-org" }
    it { expect(result).to include "apt-get install -y --force-yes mongodb-org\n" }
    it { expect(result).to_not include "'deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse'" }
  end

  describe 'install node' do
    let(:result) { logonly_escualo 'plugin install node' }

    it { expect(result).to include 'nvm install 4.2.4' }
  end

  describe 'install haskell' do
    let(:result) { logonly_escualo 'plugin install haskell' }

    it { expect(result).to eq "apt-get install -y --force-yes haskell-platform\n" }
  end
end


