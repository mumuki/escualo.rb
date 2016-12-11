module Escualo
  module Env
    def self.setup(session)
      source_escualorc = "'source ~/.escualorc'"
      session.tell_all! 'mkdir -p ~/.escualo/vars',
                        %q{echo 'for var in ~/.escualo/vars/*; do source $var; done' > ~/.escualorc},
                        %q{chmod u+x ~/.escualorc},
                        "grep -q #{source_escualorc} ~/.bashrc || echo #{source_escualorc} >> ~/.bashrc"
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
      session.tell! 'rm ~/.escualo/vars/*'
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
      session.tell_all! *variables.map { |key, value| set_command key, value }
    end

    def self.set_command(key, value)
      "echo export #{key}=#{value} > ~/.escualo/vars/#{key}"
    end

    def self.unset(session, variable_names)
      variable_names.each do |name|
        session.tell!("rm ~/.escualo/vars/#{name}")
      end
    end

    def self.locale_variables
      %w{LANG LC_ALL LC_NAME LC_IDENTIFICATION LC_PAPER LC_ADDRESS LC_TIME LC_NUMERIC LC_MONETARY LC_TELEPHONE LC_MEASUREMENT}.map do |it|
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