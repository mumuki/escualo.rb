require 'fileutils'

class Escualo::Session
  attr_accessor :options

  def initialize(options=struct)
    @options = options
  end

  def check?(command, include)
    ask(command).include? include rescue false
  end

  def tell_all!(*commands)
    tell! commands.compact.join(' && ')
  end

  def tell!(command)
    if options.verbose
      stream! command
    else
      exec! command
    end
  end

  def upload_template!(destination, name, bindings)
    write_template! name, Mumukit::Core::Template.new(File.join(__dir__, '..', 'templates', "#{name}.erb"), bindings) do |file|
      upload! file, destination
    end
  end

  def self.set_command(key, value)
    "echo export #{key}=#{value} > ~/.escualo/vars/#{key}"
  end

  def write_template!(name, template, &block)
    template.with_tempfile!('template', &block)
  end
end

require_relative './session/logonly_session'
require_relative './session/remote_session'
require_relative './session/local_session'
require_relative './session/within'
require_relative './session/environment'
