class Commander::Command
  def session_action(force_local=false, &block)
    action do |args, options|
      Escualo::Session.within(options, force_local) { |session| block.call(args, options, session) }
    end
  end

  def local_session_action(&block)
    session_action true, &block
  end
end