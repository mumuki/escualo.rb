require 'spec_helper'

describe 'escualo env' do
  describe 'set' do
    context '' do
      it { expect(dockerized_escualo 'env set FOO=BAR BAZ=GOO').to eq "ENV FOO BAR\nENV BAZ GOO\n" }
    end

    context '--unoptimized-dockerfile' do
      it { expect(dockerized_escualo 'env set FOO=BAR BAZ=GOO', '--unoptimized-dockerfile')
               .to eq "RUN echo export FOO=BAR > ~/.escualo/vars/FOO && echo export BAZ=GOO > ~/.escualo/vars/BAZ\n" }
    end
  end

  describe 'unset' do
    context '' do
      it { expect { dockerized_escualo 'env unset FOO' }.to raise_error }
    end

    context '--unoptimized-dockerfile' do
      it { expect(dockerized_escualo 'env unset FOO', '--unoptimized-dockerfile').to eq "RUN rm ~/.escualo/vars/FOO\n" }
      it { expect(dockerized_escualo 'env unset FOO BAZ', '--unoptimized-dockerfile').to eq "RUN rm ~/.escualo/vars/FOO && rm ~/.escualo/vars/BAZ\n" }
    end
  end

  describe 'clean' do
    context '' do
      it { expect { dockerized_escualo 'env clean FOO' }.to raise_error }
    end

    context '--unoptimized-dockerfile' do
      it { expect(dockerized_escualo 'env clean', '--unoptimized-dockerfile').to include 'RUN rm ~/.escualo/vars/*' }
    end
  end
end
