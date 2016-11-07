module Net::SSH::Connection::Perform
  def perform!(command, options)
    if options.verbose
      tell! command
    else
      exec! command
    end
  end
end