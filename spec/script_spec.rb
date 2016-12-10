require 'spec_helper'

describe Escualo::Script do
  describe 'run!' do
    let(:session) { Escualo::Session::Docker.new({}) }
    context 'with dockerfile' do
      context 'debian' do
        before do
          session.start! struct base_image: 'debian', write_dockerfile: true
          Escualo::Script.run! session, 'bin/escualo', ['bootstrap', 'env set FOO=BAR']
        end
        it { expect(session.dockerfile).to include "FROM debian:jessie\n" }
        it { expect(session.dockerfile).to_not include 'escualo env set' }
      end

      context 'ubuntu' do
        before do
          session.start! struct base_image: 'ubuntu', write_dockerfile: true
          Escualo::Script.run! session, 'bin/escualo', ['bootstrap', 'env set FOO=BAR', 'artifact create site baz']
        end

        it { expect(session.dockerfile).to include "FROM ubuntu:xenial\n" }
        it { expect(session.dockerfile).to include "MAINTAINER #{ENV['USER']}\n" }

        it { expect(session.dockerfile).to_not include 'escualo env set' }

        it { expect(session.dockerfile).to include "RUN apt-get update && apt-get install" }
        it { expect(session.dockerfile).to include "RUN mkdir -p /var/repo/" }
        it { expect(session.dockerfile).to include "RUN chmod +x /var/scripts/baz/init" }
        it { expect(session.dockerfile).to include "RUN chmod +x /var/repo/baz.git/hooks/post-receive" }
      end
    end
    context 'no dockerfile' do
      before do
        session.start! struct base_image: 'ubuntu', write_dockerfile: false
        Escualo::Script.run! session, 'bin/escualo', ['bootstrap', 'env set FOO=BAR']
      end

      it { expect(session.dockerfile).to_not include "FROM ubuntu:xenial\n" }
      it { expect(session.dockerfile).to_not include 'escualo env set' }
      it { expect(session.dockerfile).to include "RUN gem install bundler && gem install escualo" }
      it { expect(session.dockerfile).to include "RUN echo export FOO=BAR > ~/.escualo/vars/FOO\n" }
    end
  end

  describe 'with_commands_for' do
    let(:extra) { '--verbose=true' }

    it { expect(Escualo::Script.commands('escualo', %w(foo bar), extra).to_a).to eq ['escualo foo --verbose=true',
                                                                                     'escualo bar --verbose=true'] }
    it { expect(Escualo::Script.commands('escualo', nil, extra).to_a).to eq [] }
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


