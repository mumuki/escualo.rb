require 'spec_helper'

describe Escualo::Script do
  describe 'run!' do
    let(:session) { Escualo::Session::Docker.new({}) }
    context 'with dockerfile' do
      context 'debian' do
        before do
          session.start! struct base_image: 'debian', write_dockerfile: true
          Escualo::Script.run! session, ['bootstrap', 'env set FOO=BAR']
        end
        it { expect(session.dockerfile).to include "\nFROM debian:jessie\n" }
        it { expect(session.dockerfile).to_not include 'escualo' }
        it { expect(session.dockerfile).to include "RUN escualo bootstrap \nRUN escualo env set FOO=BAR \n" }
      end

      context 'ubuntu' do
        before do
          session.start! struct base_image: 'ubuntu', write_dockerfile: true
          Escualo::Script.run! session, ['bootstrap', 'env set FOO=BAR']
        end

        it { expect(session.dockerfile).to include "\nFROM ubuntu:xenial\n" }
        it { expect(session.dockerfile).to include "\nMAINTAINER #{ENV['USER']}\n" }

        it { expect(session.dockerfile).to_not include 'escualo' }
        it { expect(session.dockerfile).to include "RUN escualo bootstrap \nRUN escualo env set FOO=BAR \n" }
      end
    end
    context 'no dockerfile' do
      before do
        session.start! struct base_image: 'ubuntu', write_dockerfile: false
        Escualo::Script.run! session, ['bootstrap', 'env set FOO=BAR']
      end

      it { expect(session.dockerfile).to_not include "\nFROM ubuntu:xenial\n" }
      it { expect(session.dockerfile).to_not include 'escualo' }
      it { expect(session.dockerfile).to include "RUN escualo bootstrap \nRUN escualo env set FOO=BAR \n" }
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


