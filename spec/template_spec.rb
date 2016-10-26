require 'spec_helper'

describe Mumukit::Core::Template do
  let(:filename) { File.join(__dir__, '..', 'lib', 'templates', 'upstart.conf.erb') }
  let(:template) { Mumukit::Core::Template.new(filename, name: 'foo', launch_command: 'bar') }

  it { expect(template.render).to include 'chdir /var/www/foo' }
  it do
    template.with_tempfile!('foo') do |file|
      expect(File.read file).to include 'for var in /root/.escualo/vars/*; do . \\\\$var; done'
    end
  end
end


