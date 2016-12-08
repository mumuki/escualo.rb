require 'spec_helper'

describe 'escualo env', dockerized: true do
  it 'can list env' do
    result, status = escualo 'env list', 'bootstrapped.yml'

    expect(status).to eq 0
    expect(result).to include 'LANG=en_US.UTF-8'
    expect(result).to include 'RACK_ENV=production'
    expect(result).to include 'ESCUALO_BASE_VERSION'
    expect(result).to_not include 'FOO'
  end

  it 'can set env' do
    result, status = escualo 'env list', 'with.foo.env.yml'

    expect(status).to eq 0
    expect(result).to include 'FOO=BAR'
  end

  it 'can unset env' do
    result, status = escualo 'env unset RACK_ENV ESCUALO_BASE_VERSION', 'bootstrapped.yml'

    expect(status).to eq 0
    expect(result).to include 'LANG'
    expect(result).to_not include 'RACK_ENV'
    expect(result).to_not include 'ESCUALO_BASE_VERSION'
  end
end