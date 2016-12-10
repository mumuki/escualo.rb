require 'spec_helper'

describe Escualo::Session do
  it do
    session = nil
    Escualo::Session.within(struct) { |it| session = it }
    expect(session).to be_a Escualo::Session::Local
  end

  it do
    session = nil
    Escualo::Session.within(struct dockerized: true) { |it| session = it }
    expect(session).to be_a Escualo::Session::Docker
  end

  it do
    expect(Escualo::Session).to receive(:within_ssh_session)
    Escualo::Session.within(struct hostname: 'foo.com') {}
  end

  it do
    expect(Escualo::Session).to receive(:within_ssh_session)
    Escualo::Session.within(struct ssh_port: '4444')
  end

  it do
    expect(Escualo::Session).to receive(:within_ssh_session)
    Escualo::Session.within(struct username: 'astor')
  end


  describe Escualo::Session::Local do
    let(:session) { Escualo::Session::Local.new }
    it { expect(session.ask 'ls ./spec/data').to eq "based.yml\nbootstrapped.yml\nempty.yml\nfull.yml\nserviced.yml\nwith.foo.env.yml\n" }

    describe 'tell!' do
      it { session.tell! 'ls ./spec/data' }
      it { expect { session.tell! 'ls ./spec/this-repo-does-not-exist' }.to raise_error RuntimeError }
    end

    describe 'check?' do
      it { expect(session.check? 'the-rare-command', 'foo').to be false }
      it { expect(session.check? 'ls ./spec/data', 'the-rare-output').to be false }
      it { expect(session.check? 'ls ./spec/data', 'empty.yml').to be true }
    end

    it { expect { session.exec! 'ls ./spec/this-repo-does-not-exist' }.to raise_error RuntimeError }
  end

  describe Escualo::Session::Docker do
    let(:session) { Escualo::Session::Docker.started }

    describe 'ask' do
      it { expect { session.ask 'ls ./spec/data' }.to raise_error RuntimeError }
    end

    describe 'tell!' do
      before { session.tell! 'foo' }
      it { expect(session.dockerfile).to eq "RUN foo\n" }
    end

    describe 'tell_all!' do
      context 'no nil command' do
        before { session.tell_all! 'foo', 'bar', 'baz' }
        it { expect(session.dockerfile).to eq "RUN foo && bar && baz\n" }
      end

      context 'nil command' do
        before { session.tell_all! 'foo', nil, 'baz' }
        it { expect(session.dockerfile).to eq "RUN foo && baz\n" }
      end
    end
  end
end