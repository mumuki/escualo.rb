class Commander::Command
  def session_action(&block)
    action do |args, options|
      Escualo::Session.within(options) { |session| block.call(args, options, session) }
    end
  end
end