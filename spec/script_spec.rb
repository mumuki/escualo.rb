require 'spec_helper'

describe 'escualo script', if: vagrant_up do
  it 'can run simple atheneum server script', if: vagrant_up do
    result = escualo 'script samples/server.simple.atheneum.yml'
    expect($?).to eq 0

    expect(ssh 'ruby --version').to include 'ruby 2.0'
    expect(ssh 'psql --version').to include 'PostgreSQL'

    expect(result).to_not include 'ERROR'

    expect(ssh 'service atheneum status').to include 'atheneum start/running'

  end

  it 'can run development platform script', if: vagrant_up do
    result = escualo 'script samples/development.platform.yml'
    expect($?).to eq 0

    expect(ssh 'ruby --version').to include 'ruby 2.0'
    expect(ssh 'psql --version').to include 'PostgreSQL'
    expect(ssh 'mongod --version').to include 'db version'

    expect(result).to_not include 'ERROR'
  end

  it 'can run desktop atheneum script', if: vagrant_up do
    result = escualo 'script samples/desktop.atheneum.yml'
    expect($?).to eq 0

    expect(ssh 'ruby --version').to include 'ruby 2.0'
    expect(ssh 'psql --version').to include 'PostgreSQL'

    expect(result).to_not include 'ERROR'

    expect(ssh 'service atheneum status').to include 'atheneum start/running'
  end
end


