describe 'escualo env set' do
  it { expect(dockerized_escualo 'env set FOO=BAR BAZ=GOO').to eq "RUN echo export FOO=BAR > ~/.escualo/vars/FOO && echo export BAZ=GOO > ~/.escualo/vars/BAZ\n" }
  it { expect(dockerized_escualo 'env unset FOO BAZ').to eq "RUN rm ~/.escualo/vars/FOO\nRUN rm ~/.escualo/vars/BAZ\n" }
end
