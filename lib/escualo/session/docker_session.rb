class Escualo::Session::Docker < Escualo::Session
  attr_accessor :dockerfile

  def unset_environment_variables!(*)
    raise 'can not unset variables on dockerfile optimized mode' unless options.unoptimized_dockerfile
    super
  end

  def clean_environment_variables!(*)
    raise 'can not clean variables on dockerfile optimized mode' unless options.unoptimized_dockerfile
    super
  end

  def setup_environment_variables!
    super if options.unoptimized_dockerfile
  end

  def set_environment_variables!(variables)
    return super if options.unoptimized_dockerfile
    variables.each do |key, value|
      dockerfile << "ENV #{key} #{value}\n"
    end
  end

  def embed!(command)
    dockerfile << Open3.exec!("#{command} --dockerized")
  end

  def tell!(command)
    dockerfile << "RUN #{command}\n"
  end

  def upload!(file, destination)
    dockerfile << "COPY #{file} #{destination}\n"
  end

  def write_template!(name, template, &block)
    template.write! name
    block.call name
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