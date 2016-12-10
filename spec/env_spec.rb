require 'spec_helper'

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
end