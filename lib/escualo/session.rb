require 'fileutils'
require 'open3'

class Escualo::Session
  attr_accessor :options

  def initialize(options=struct)
    @options = options
  end

  def embed!(command)
    tell! command
  end

  def tell_all!(*commands)
    tell! commands.join(' && ')
  end

  def tell!(command)
    if options.verbose
      exec! command
    else
      stream! command
    end
  end

  def upload_template!(destination, name, bindings)
    Mumukit::Core::Template
        .new(File.join(__dir__, '..', 'templates', "#{name}.erb"), bindings)
        .with_tempfile!('template') do |file|
      upload! file, destination
    end
  end

  def self.parse_session_options(options)
    struct username: options.username || 'root',
           hostname: options.hostname || 'localhost',
           ssh_options: {
               keys: [options.ssh_key].compact,
               port: options.ssh_port || 22
           },
           verbose: options.verbose,
           local: options.hostname.blank? && options.username.blank? && options.ssh_key.blank? && options.ssh_port.blank?,
           dockerized: options.dockerized
  end

  def self.within(options, &block)
    session_options = parse_session_options options

    if session_options.dockerized
      within_dockerized_session session_options, options, &block
    elsif session_options.local
      block.call(Escualo::Session::Local.new session_options)
    else
      within_ssh_session(session_options, &block)
    end
  end

  def self.within_dockerized_session(session_options, options, &block)
    session = Escualo::Session::Docker.new session_options
    session.start! options
    block.call(session)
    session.finish! options
  end

  def self.within_ssh_session(session_options, &block)
    Net::SSH.start(
        session_options.hostname,
        session_options.username,
        session_options.ssh_options) do |ssh|
      block.call(Escualo::Session::Remote.new ssh, session_options)
    end
  end
end

require_relative './session/docker_session'
require_relative './session/remote_session'
require_relative './session/local_session'
