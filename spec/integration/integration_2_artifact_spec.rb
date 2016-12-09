require 'spec_helper'

describe 'escualo artifact create', dockerized: true do
  it 'create service' do
    result = scripted_escualo 'artifact create service atheneum 80', 'bootstrapped.yml'
    expect(result).to eq ['', 0]
  end

  it 'can create executable' do
    result = scripted_escualo 'artifact create executable mulang', 'bootstrapped.yml'
    expect(result).to eq ['', 0]
  end

  it 'can create site' do
    result = scripted_escualo 'artifact create site editor', 'bootstrapped.yml'
    expect(result).to eq ['', 0]
  end

  it 'can destroy artifact' do
    result = scripted_escualo 'artifact destroy atheneum', 'serviced.yml'
    expect(result).to eq ['', 0]
  end
end


