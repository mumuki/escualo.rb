require 'spec_helper'

describe 'escualo remote' do
  describe 'remote_git_url' do
    context 'remote' do
      before do
        $ssh_remote = true
        $ssh_port = 2222
        $username = 'the-user'
        $hostname = 'the-hostname'
      end
      it { expect(Escualo::Remote.remote_git_url 'foo').to eq 'ssh://the-user@the-hostname:2222/var/repo/foo.git' }
    end
    context 'local' do
      before { $ssh_remote = false }
      it { expect(Escualo::Remote.remote_git_url 'foo').to eq '/var/repo/foo.git' }
    end
  end

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