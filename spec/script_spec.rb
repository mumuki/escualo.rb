require 'spec_helper'

describe 'escualo script' do
  it 'can run simple scripts', if: vagrant_up do
    result = escualo 'script data/atheneum.yml'
    expect($?).to eq 0
    expect(result).to include 'Script executed successfully'
  end
end


