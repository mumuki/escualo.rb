require 'spec_helper'

describe Escualo::Remote do
  describe 'remote_git_url' do
    let(:session_options) { Escualo::Session.parse_session_options options }

    context 'remote' do
      let(:options) { struct ssh_port: 2222,
                             username: 'the-user',
                             hostname: 'the-hostname' }

      it { expect(Escualo::Remote.remote_git_url 'foo', session_options).to eq 'ssh://the-user@the-hostname:2222/var/repo/foo.git' }
    end
    context 'remote no options' do
      let(:options) { struct ssh_port: 44 }

      it { expect(Escualo::Remote.remote_git_url 'foo', session_options).to eq 'ssh://root@localhost:44/var/repo/foo.git' }
    end
    context 'local' do
      let(:options) { struct }
      it { expect(Escualo::Remote.remote_git_url 'foo', session_options).to eq '/var/repo/foo.git' }
    end
    context 'dockerized' do
      let(:options) { struct dockerized: true }
      it { expect(Escualo::Remote.remote_git_url 'foo', session_options).to eq '/var/repo/foo.git' }
    end
  end
end