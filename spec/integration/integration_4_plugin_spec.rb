require 'spec_helper'

describe 'plugin', dockerized: true do
  it 'installs docker' do
    result = escualo 'plugin install docker', 'bootstrapped.yml'
    expect(result).to eq ['', 0]
  end

  it 'installs monit' do
    result = escualo 'plugin install monit --monit-password abcdefg', 'bootstrapped.yml'
    expect(result).to eq ['', 0]
  end

  it 'installs haskell' do
    result = escualo 'plugin install haskell', 'bootstrapped.yml'
    expect(result).to eq ['', 0]
  end

  it 'installs mongo ' do
    result = escualo 'plugin install mongo', 'bootstrapped.yml'
    expect(result).to eq ['', 0]
  end

  it 'installs nginx ' do
    result = escualo 'plugin install nginx', 'bootstrapped.yml'
    expect(result).to eq ['', 0]
  end

  it 'installs node ' do
    result = escualo 'plugin install node', 'bootstrapped.yml'
    expect(result).to eq ['', 0]
  end

  it 'installs postgre ' do
    result = escualo 'plugin install postgre', 'bootstrapped.yml'
    expect(result).to eq ['', 0]
  end

  it 'installs rabbit ' do
    result = escualo 'plugin install rabbit --rabbit-admin-password 12345678', 'bootstrapped.yml'
    expect(result).to eq ['', 0]
  end
end