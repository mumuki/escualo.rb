module Escualo::AptGet
  def self.install(session, packages_string, options={})
    session.tell_all! update_command(options),
                      "apt-get install -y --force-yes #{packages_string}"
  end

  def self.update_command(options)
    'apt-get update' if options[:update]
  end
end