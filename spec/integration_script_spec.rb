require 'spec_helper'

describe 'escualo script' do
  it 'can run simple atheneum server script', if: vagrant_up do
    result = escualo 'script spec/data/sample.script.yml'
    expect($?).to eq 0

    expect(ssh 'ruby --version').to include 'ruby 2.3'
    expect(ssh 'psql --version').to include 'PostgreSQL'

    expect(result).to_not include 'ERROR'
    expect(ssh 'service atheneum status').to include 'atheneum start/running'
  end
end


