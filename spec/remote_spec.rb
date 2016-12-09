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

describe 'escualo remote' do

  describe 'attach' do
    it 'adds a git remote to the current repository' do
      remotes = Dir.mktmpdir do |dir|
        %x{cd #{dir} && git init .}
        raw_escualo "remote attach foo --hostname deploy.com --username astor --repo-path #{dir}"
        raw_escualo "remote show --repo-path #{dir}"
      end

      expect(remotes).to include 'escualo-foo-deploy.com'
      expect(remotes.split.size).to eq 1
    end

    it 'supports adding multiple attachments' do
      remotes = Dir.mktmpdir do |dir|
        %x{cd #{dir} && git init .}
        raw_escualo "remote attach foo --hostname s1.deploy.com --username astor --repo-path #{dir}"
        raw_escualo "remote attach foo --hostname s2.deploy.com --username astor --repo-path #{dir}"
        raw_escualo "remote attach bar --hostname s3.deploy.com --username astor --repo-path #{dir}"
        raw_escualo "remote show --repo-path #{dir}"
      end

      expect(remotes).to include 'escualo-foo-s1.deploy.com'
      expect(remotes).to include 'escualo-foo-s2.deploy.com'
      expect(remotes).to include 'escualo-bar-s3.deploy.com'
      expect(remotes.split.size).to eq 3
    end
  end
end