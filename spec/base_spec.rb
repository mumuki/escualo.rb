require 'spec_helper'

describe 'escualo base' do
  let(:result) { dockerized_escualo 'base' }

  it { expect(result).to include 'RUN apt-get purge -y locales' }
  it { expect(result).to include 'RUN apt-get update && apt-get install -y' }
  it { expect(result).to include '--force-yes' }
  it { expect(result).to include 'autoconf' }

end


