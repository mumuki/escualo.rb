module Net::SSH::Connection::Upload
  def upload_template!(destination, name, bindings)
    Mumukit::Core::Template
        .new(File.join(__dir__, 'templates', "#{name}.erb"), bindings)
        .with_tempfile!('template') do |file|
      upload_file! file, destination
    end
  end
end