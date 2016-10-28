require 'spec_helper'

describe 'escualo --help' do
  it { expect(escualo '--help').to include 'escualo provisioning tool implementation for ruby' }
end