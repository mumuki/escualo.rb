require 'spec_helper'

describe Net::SSH::Connection::LocalSession do
  it do
    session = nil
    Net::SSH.with_session(local: true) { |ssh| session = ssh }
    expect(session).to be_a Net::SSH::Connection::LocalSession
  end
end