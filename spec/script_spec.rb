require 'spec_helper'

describe 'escualo script' do
  it 'can run simple scripts', if: vagrant_up do
    result = escualo 'script spec/data/atheneum.yml'
    expect($?).to eq 0

    expect(ssh 'ruby --version').to include 'ruby 2.0'
    expect(ssh 'psql --version').to include 'PostgreSQL'
    expect(ssh 'service atheneum status').to include 'atheneum start/running'
  end
end


