require 'spec_helper'

describe Escualo::Vars do
  it { expect(Escualo::Vars.locale_variables).to eq "LANG" => "en_US.UTF-8",
                                                    "LC_ADDRESS" => "en_US.UTF-8",
                                                    "LC_ALL" => "en_US.UTF-8",
                                                    "LC_MEASUREMENT" => "en_US.UTF-8",
                                                    "LC_MONETARY" => "en_US.UTF-8",
                                                    "LC_NAME" => "en_US.UTF-8",
                                                    "LC_NUMERIC" => "en_US.UTF-8",
                                                    "LC_PAPER" => "en_US.UTF-8",
                                                    "LC_TELEPHONE" => "en_US.UTF-8" }
  it { expect(Escualo::Vars.production_variables).to eq "NODE_ENV" => "production",
                                                        "RACK_ENV" => "production",
                                                        "RAILS_ENV" => "production" }
end