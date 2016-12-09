class Escualo::Session::Docker < Escualo::Session
  attr_accessor :dockerfile

  def embed!(command)
    dockerfile << %x{#{command} --dockerized}
  end

  def tell!(command)
    dockerfile << "RUN #{command}\n"
  end

  def upload!(file, destination)
    dockerfile << "COPY #{file.path} #{destination}\n"
  end

  def ask(*)
    raise 'can not ask on a docker session'
  end

  def start!(options)
    if options.write_dockerfile
      @dockerfile = "FROM #{base_image options}\nMAINTAINER #{ENV['USER']}\n"
    else
      @dockerfile = ''
    end
  end

  def base_image(options)
    if options.base_image == 'ubuntu'
      'ubuntu:xenial'
    elsif options.base_image == 'debian'
      'debian:jessie'
    else
      raise "Unsupported base image #{options.base_image}. Only debian and ubuntu are supported"
    end
  end

  def finish!(options)
    if options.write_dockerfile
      File.write('Dockerfile', dockerfile)
    else
      puts dockerfile
    end
  end

  def self.started(options = struct)
    new.tap do |it|
      it.start!(options)
    end
  end
end