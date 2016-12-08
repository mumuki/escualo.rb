require 'spec_helper'

describe Net::SSH::Connection::LocalSession do
  it do
    session = nil
    Net::SSH.with_session(local: true) { |ssh| session = ssh }
    expect(session).to be_a Net::SSH::Connection::LocalSession
  end

  let(:session) { Net::SSH::Connection::LocalSession.new }
  it { expect(session.exec! 'ls ./spec/data').to eq "sample.script.yml\n" }
  it { session.tell! 'ls ./spec/data' }

  it { expect { session.exec! 'ls ./spec/this-repo-does-not-exist' }.to raise_error RuntimeError }
  it { expect { session.tell! 'ls ./spec/this-repo-does-not-exist' }.to raise_error RuntimeError }

end