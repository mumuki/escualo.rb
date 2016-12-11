class Net::SSH::Connection::Session
  def stream!(command)
    exit_code = 0
    channel = self.open_channel do |channel|
      channel.exec command do |ch, success|
        raise 'could not execute command' unless success
        ch.on_data do |c, data|
          yield :stdout, data unless garbage? data
        end
        ch.on_extended_data do |c, type, data|
          yield :stderr, data unless garbage? data
        end
        ch.on_request('exit-status') do |c, data|
          exit_code = data.read_long
        end
      end
    end
    channel.wait
    raise "command failed #{command}!" if exit_code != 0
    nil
  end

  def garbage?(data)
    data.start_with?('bash: cannot set terminal process group') || data.start_with?('bash: no job control in this shell')
  end
end