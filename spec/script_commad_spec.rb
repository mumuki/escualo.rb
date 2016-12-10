require 'spec_helper'

describe 'escualo script' do
  it { expect(dockerized_escualo 'script spec/data/empty.yml').to eq "\n" }
  it { expect(dockerized_escualo 'script spec/data/bootstrapped.yml').to include 'RUN apt-get update && apt-get install' }
  it { expect(dockerized_escualo 'script spec/data/serviced.yml').to include 'RUN apt-get update && apt-get install' }
  it { expect(dockerized_escualo 'script spec/data/with.foo.env.yml').to include 'RUN apt-get update && apt-get install' }
  it { expect(dockerized_escualo 'script spec/data/full.yml').to include 'RUN apt-get update && apt-get install' }
end