require 'spec_helper'

describe Escualo::Base do
  describe 'add_repositories' do
    let(:result) { logonly { |s| Escualo::Base.add_repositories s } }

    it { expect(result).to include 'rabbit' }
    it { expect(result).to include 'mongo' }
    it { expect(result).to include 'nginx' }
    it { expect(result).to include 'ruby' }
    it { expect(result).to include 'postgres' }

    it { expect(result).to include 'apt-get update' }
  end

  describe 'install' do
    let(:result) { logonly { |s| Escualo::Base.install s } }

    it { expect(result).to include 'apt-get install' }
  end

  describe 'configure_locales' do
    let(:result) { logonly { |s| Escualo::Base.configure_locales s } }

    it { expect(result).to include 'apt-get purge -y locales' }
    it { expect(result).to include 'debconf-set-selections' }
    it { expect(result).to include 'apt-get install -y --force-yes locales' }
  end
end


