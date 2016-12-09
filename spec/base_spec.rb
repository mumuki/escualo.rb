require 'spec_helper'

describe 'escualo base' do
  let(:result) { dockerized_escualo 'base' }
  it { expect(result).to include 'RUN apt-get install -y autoconf' }
end


