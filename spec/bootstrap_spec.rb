require 'spec_helper'

describe 'escualo bootstrap' do
  let(:result) { dockerized_escualo 'bootstrap' }

  it { expect(result).to include 'RUN locale-gen en_US.UTF-8' }
  it { expect(result).to include 'RUN echo export ESCUALO_BASE_VERSION=' }
  it { expect(result).to include 'RUN apt-get purge libruby* -y' }
  it { expect(result).to include 'apt-get install -y ruby2.3 ruby2.3-dev' }
  it { expect(result).to include 'RUN gem install bundler && gem install escualo' }
  it { expect(result).to include 'RUN mkdir -p /var/repo/ && mkdir -p /var/scripts/'}
  it { expect(result).to include 'RAILS_ENV=development' }
  it { expect(result).to include 'RACK_ENV=development' }

  describe '--with-rbenv' do
    let(:result) { dockerized_escualo 'bootstrap --with-rbenv' }

    it { expect(result).to include 'RUN curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer' }
    it { expect(result).to_not include 'apt-get install -y ruby2.3 ruby2.3-dev' }
  end


  describe '--swap' do
    let(:result) { dockerized_escualo 'bootstrap --swap' }

    it { expect(result).to include 'RUN test -e /swapfile' }
  end

  describe '--env development' do
    let(:result) { dockerized_escualo 'bootstrap --env development' }

    it { expect(result).to include 'RAILS_ENV=development' }
    it { expect(result).to include 'RACK_ENV=development' }
    it { expect(result).to_not include 'RACK_ENV=production' }
  end

end


