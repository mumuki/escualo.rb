require 'spec_helper'

describe 'escualo --help' do
  it do
    escualo '--help'
    expect($?).to eq 0
  end
end