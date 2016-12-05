require 'spec_helper'

describe 'escualo bootstrap', if: vagrant_up do
  it 'can bootstrap' do
    escualo 'bootstrap --monit-password sample'

    expect($?).to eq 0

    expect(ssh 'ruby --version').to include 'ruby 2.3'
    expect(ssh 'monit --version').to include 'This is Monit version 5'
  end
end


