require 'spec_helper'

describe "escualo --version" do
  it { expect(escualo "--version").to eq "escualo #{Escualo::VERSION}\n" }
end