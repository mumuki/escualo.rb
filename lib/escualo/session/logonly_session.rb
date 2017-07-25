class Escualo::Session::Logonly < Escualo::Session
  attr_accessor :log

  def set_environment_variables!(variables)
    variables.each do |key, value|
      log << "export #{key}=#{value}\n"
    end
  end

  def tell!(command)
    log << "#{command}\n"
  end

  def upload!(file, destination)
    log << "cp #{file} #{destination}\n"
  end

  def write_template!(name, template, &block)
    template.write! name
    block.call name
  end

  def ask(*)
    raise 'can not ask on a logonly session'
  end

  def start!(_options)
    @log = ''
  end

  def finish!(_options)
    puts log
  end

  def self.started(options = struct)
    new.tap do |it|
      it.start!(options)
    end
  end
end
