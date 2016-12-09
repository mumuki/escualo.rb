require 'spec_helper'

describe 'escualo bootstrap', dockerized: true do
  it 'bootstrap' do
    result = escualo 'bootstrap --trace --verbose', 'based.yml'
    expect(result).to eq ['', 0]
  end
end


