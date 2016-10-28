require 'spec_helper'

describe 'escualo --version' do
  it { expect(raw_escualo '--version').to eq "escualo #{Escualo::VERSION}\n" }
end