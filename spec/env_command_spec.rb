require 'spec_helper'

describe 'escualo env' do
  describe 'set' do
    it { expect(logonly_escualo 'env set FOO=BAR BAZ=GOO').to eq "export FOO=BAR\nexport BAZ=GOO\n" }
  end
end


