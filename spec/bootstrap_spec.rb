require 'spec_helper'

describe 'escualo bootstrap' do
  it 'can force bootstrap' do
    escualo "bootstrap --monit-password sample --force "

    expect($?).to eq 0
  end
end


