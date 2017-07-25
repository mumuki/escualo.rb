require 'spec_helper'

describe 'escualo bootstrap' do
  let(:result) { logonly_escualo 'bootstrap' }

  it { expect(result).to include 'apt-get purge -y locales' }
  it { expect(result).to include 'apt-get update && apt-get install -y' }
  it { expect(result).to include '--force-yes' }
  it { expect(result).to include 'autoconf' }
  it { expect(result).to include 'export ESCUALO_BASE_VERSION=' }
  it { expect(result).to include 'apt-get purge libruby* -y' }
  it { expect(result).to include 'apt-get install -y --force-yes ruby2.3 ruby2.3-dev' }
  it { expect(result).to include 'gem install bundler && gem install escualo' }
  it { expect(result).to include 'mkdir -p /var/repo/ && mkdir -p /var/scripts/'}
  it { expect(result).to include 'export RAILS_ENV=production' }
  it { expect(result).to include 'export RACK_ENV=production' }

  describe '--with-rbenv' do
    let(:result) { logonly_escualo 'bootstrap --with-rbenv' }

    it { expect(result).to include 'curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer' }
    it { expect(result).to_not include 'apt-get install -y ruby2.3 ruby2.3-dev' }
  end


  describe '--swap' do
    let(:result) { logonly_escualo 'bootstrap --swap' }

    it { expect(result).to include 'test -e /swapfile' }
    it { expect(result).to include 'swapon /swapfile' }
  end

  describe '--env development' do
    let(:result) { logonly_escualo 'bootstrap --env development' }

    it { expect(result).to include "export RAILS_ENV=development\n" }
    it { expect(result).to include "export RACK_ENV=development\n" }
    it { expect(result).to_not include "export RACK_ENV=production\n" }
  end

end


