class Net::SSH::Connection::Session
  def upload_template!(destination, name, bindings)
    file = Tempfile.new('template')

    Mumukit::Core::Template
      .new(File.join(__dir__, 'templates', "#{name}.erb"), bindings)
      .write! file

    scp.upload! file, destination
  ensure
    file.unlink
    file.close
  end
end