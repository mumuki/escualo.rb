require 'spec_helper'

describe Escualo::AptGet do
  context 'no update' do
    let(:result) { dockerized { |s| Escualo::AptGet.install(s, 'ruby postgres wget') } }
    it { expect(result).to eq "RUN apt-get install -y --force-yes ruby postgres wget\n" }
  end
  context 'with update' do
    let(:result) { dockerized { |s| Escualo::AptGet.install(s, 'ruby postgres wget', update: true) } }
    it { expect(result).to eq "RUN apt-get update && apt-get install -y --force-yes ruby postgres wget\n" }
  end
end

