require 'spec_helper'

describe 'escualo artifact create' do
  before do
    escualo('list').split.each do |it|
      escualo "artifact destroy #{it}"
    end
  end

  it 'can create service' do
    result = escualo 'artifact create service atheneum 80'
    expect($?).to eq 0

    expect(result).to include 'Service atheneum created successfully'
    expect(result).to include 'Now you can deploy this service'

    expect(escualo 'artifact list').to include 'atheneum'
  end

  it 'can create executable' do
    result = escualo 'artifact create executable mulang'
    expect($?).to eq 0
    expect(result).to include 'Executable mulang created successfully'
    expect(result).to include 'Now you can deploy this executable'

    expect(escualo 'artifact list').to include 'mulang'
  end

  it 'can create site' do
    result = escualo 'artifact create site editor'
    expect($?).to eq 0
    expect(result).to include 'Site editor created successfully'
    expect(result).to include 'Now you can deploy this site'

    expect(escualo 'artifact list').to include 'editor'
  end

  it 'can destroy service' do
    escualo 'artifact create service zaraza 80'
    escualo 'artifact destroy zaraza'

    expect(escualo 'artifact list').to_not include 'zaraza'
  end
end


