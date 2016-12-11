require 'spec_helper'

describe 'escualo base', dockerized: true do
  it 'base' do
    result = scripted_escualo 'base --trace --verbose', 'empty.yml'
    expect(result).to eq ['', 0]
  end
end


