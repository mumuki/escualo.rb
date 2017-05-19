module Escualo
  module Env
    def self.setup(session)
      session.setup_environment_variables!
    end

    def self.set_builtins(session, options)
      set session, ESCUALO_BASE_VERSION: Escualo::BASE_VERSION
      set session, Escualo::Env.locale_variables
      set session, Escualo::Env.environment_variables(options.env)
    end

    def self.list(session)
      session.ask('cat ~/.escualo/vars/*').gsub('export ', '')
    end

    def self.clean(session, options)
      session.clean_environment_variables!

      set_builtins session, options
    end

    def self.present?(session, variable)
      get(session, variable).present?
    rescue
      false
    end

    def self.get(session, variable)
      session.ask("cat ~/.escualo/vars/#{variable}")
    end

    def self.set(session, variables)
      session.set_environment_variables! variables
    end

    def self.unset(session, variable_names)
      session.unset_environment_variables! variable_names
    end

    def self.unset_command(name)
      "rm ~/.escualo/vars/#{name}"
    end

    def self.clean_command
      'rm ~/.escualo/vars/*'
    end

    def self.set_command(key, value)
      "echo export #{key}=#{value} > ~/.escualo/vars/#{key}"
    end

    def self.locale_variables
      %w{LANG LANGUAGE
        LC_ALL LC_NAME LC_IDENTIFICATION LC_PAPER LC_ADDRESS LC_TIME
        LC_NUMERIC LC_MONETARY LC_TELEPHONE LC_MEASUREMENT}.map do |it|
        [it, locale]
      end.to_h
    end

    def self.locale
      'en_US.UTF-8'
    end

    def self.environment_variables(environment)
      %w{RAILS_ENV NODE_ENV RACK_ENV}.map do |it|
        [it, environment]
      end.to_h
    end

    def self.locale_export
      locale_variables.map { |key, value| "#{key}=#{value}" }.join(' ')
    end
  end
end