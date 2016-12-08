require 'spec_helper'

describe Escualo::Script do
  describe Escualo::Script::Mode do
    let(:mode) { Escualo::Script::Dockerized.new }
    context 'debian' do
      before do
        mode.start! struct base_image: 'debian'
        mode.run_commands_for! ['bootstrap', 'env set FOO=BAR'], nil, {}
      end
      it { expect(mode.dockerfile).to include "\nFROM debian:jessie\n" }
      it { expect(mode.dockerfile).to include "RUN apt-get update && apt-get install ruby ruby-dev build-essential -y\nRUN gem install escualo\n" }
      it { expect(mode.dockerfile).to include "RUN escualo bootstrap \nRUN escualo env set FOO=BAR \n" }
    end

    context 'ubuntu' do
      before do
        mode.start! struct base_image: 'ubuntu'
        mode.run_commands_for! ['bootstrap', 'env set FOO=BAR'], nil, {}
      end
      it { expect(mode.dockerfile).to include "\nFROM ubuntu:xenial\n" }
      it { expect(mode.dockerfile).to include "RUN apt-get update && apt-get install ruby ruby-dev build-essential -y\nRUN gem install escualo\n" }
      it { expect(mode.dockerfile).to include "RUN escualo bootstrap \nRUN escualo env set FOO=BAR \n" }
    end
  end

  describe 'with_commands_for' do
    let(:extra) { '--verbose=true' }

    it { expect(Escualo::Script.each_command(%w(foo bar), extra).to_a).to eq ['escualo foo --verbose=true',
                                                                              'escualo bar --verbose=true'] }
    it { expect(Escualo::Script.each_command(nil, extra).to_a).to eq [] }
  end

  describe 'delegated_options' do
    it { expect(Escualo::Script.delegated_options(struct ssh_port: 2222,
                                                         trace: true)).to eq '--ssh-port 2222 --trace' }

    it { expect(Escualo::Script.delegated_options(struct username: 'root',
                                                         ssh_port: 2222,
                                                         verbose: true)).to eq '--username root --ssh-port 2222 --verbose' }

    it { expect(Escualo::Script.delegated_options(struct username: 'root',
                                                         trace: nil)).to eq '--username root' }
  end
end


