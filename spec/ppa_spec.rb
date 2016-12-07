require 'spec_helper'

describe Escualo::PPA do
  it { expect(Escualo::PPA.for 'brightbox/ruby-ng').to eq 'deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main' }
end