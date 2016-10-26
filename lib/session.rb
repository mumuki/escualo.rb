class Net::SSH::Connection::Session
  def upload_template!(destination, name, bindings)
    Mumukit::Core::Template
        .new(File.join(__dir__, 'templates', "#{name}.erb"), bindings)
        .with_tempfile!('template') do |file|
      scp.upload! file, destination
    end
  end
end