require 'spec_helper'

describe 'escualo env set' do
  it { expect(dockerized_escualo 'env set FOO=BAR BAZ=GOO').to eq "RUN echo export FOO=BAR > ~/.escualo/vars/FOO && echo export BAZ=GOO > ~/.escualo/vars/BAZ\n" }
end

describe Escualo::Env do

  it { expect(Escualo::Env.set_command 'FOO', 'bar').to eq 'echo export FOO=bar > ~/.escualo/vars/FOO' }
  it { expect(Escualo::Env.set_command 'FOO', '"bar"').to eq "echo export FOO=\"bar\" > ~/.escualo/vars/FOO" }
  it { expect(Escualo::Env.set_command 'FOO', "'bar'").to eq "echo export FOO='bar' > ~/.escualo/vars/FOO" }
  it { expect(Escualo::Env.set_command 'FOO', "'ba*r'").to eq "echo export FOO='ba*r' > ~/.escualo/vars/FOO" }

  it { expect(Escualo::Env.locale_variables).to eq 'LANG' => 'en_US.UTF-8',
                                                   'LC_ADDRESS' => 'en_US.UTF-8',
                                                   'LC_ALL' => 'en_US.UTF-8',
                                                   'LC_IDENTIFICATION' => 'en_US.UTF-8',
                                                   'LC_MEASUREMENT' => 'en_US.UTF-8',
                                                   'LC_MONETARY' => 'en_US.UTF-8',
                                                   'LC_NAME' => 'en_US.UTF-8',
                                                   'LC_NUMERIC' => 'en_US.UTF-8',
                                                   'LC_PAPER' => 'en_US.UTF-8',
                                                   'LC_TELEPHONE' => 'en_US.UTF-8',
                                                   'LC_TIME' => 'en_US.UTF-8' }
  it { expect(Escualo::Env.environment_variables('production')).to eq 'NODE_ENV' => 'production',
                                                                      'RACK_ENV' => 'production',
                                                                      'RAILS_ENV' => 'production' }

  describe 'set_locale' do
    let(:session) { Escualo::Session::Docker.started }

    before { Escualo::Env.set_locale(session) }

    it { expect(session.dockerfile).to eq "RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8\n"}
  end
end