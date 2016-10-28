require 'spec_helper'

describe 'escualo create' do
  it 'can create service' do
    result = escualo 'create service atheneum 80'
    expect($?).to eq 0

    expect(result).to include 'Service atheneum created successfully'
    expect(result).to include 'Now you can deploy this service'
    expect(escualo 'artifacts list').to include 'atheneum'
  end

  it 'can create executable' do
    result = escualo 'create executable mulang'
    expect($?).to eq 0
    expect(result).to include 'Executable mulang created successfully'
    expect(result).to include 'Now you can deploy this executable'
    expect(escualo 'artifacts list').to include 'mulang'

  end

  it 'can create site' do
    result = escualo 'create site editor'
    expect($?).to eq 0
    expect(result).to include 'Site editor created successfully'
    expect(result).to include 'Now you can deploy this site'
    expect(escualo 'artifacts list').to include 'editor'
  end
end


