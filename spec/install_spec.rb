require 'spec_helper'

describe 'install' do
  before { escualo "bootstrap --monit-password sample" }

  it "installs docker" do
    result = escualo "install docker"

    expect(result).to include "Successfully installed"
    expect($?).to eq 0
  end

  it "installs mongo" do
    result = escualo "install mongo"

    expect(result).to include "Successfully installed"
    expect($?).to eq 0
  end

  it "installs haskell" do
    result = escualo "install haskell"

    expect(result).to include "Successfully installed"
    expect($?).to eq 0
  end

  it "installs rabbit" do
    result = escualo "install rabbit"

    expect(result).to include "Successfully installed"
    expect($?).to eq 0
  end

  it "installs postgre" do
    result = escualo "install postgre"

    expect(result).to include "Successfully installed"
    expect($?).to eq 0
  end
end