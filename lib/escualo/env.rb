module Escualo
  module Env
    def self.setup(ssh)
      source_escualorc = "'source ~/.escualorc'"
      ssh.exec! %Q{
        mkdir -p ~/.escualo/vars && \
        echo 'for var in ~/.escualo/vars/*; do source $var; done' > ~/.escualorc && \
        chmod u+x ~/.escualorc && \
        grep -q #{source_escualorc} ~/.bashrc || echo #{source_escualorc} >> ~/.bashrc
      }
    end

    def self.set_locale(ssh, options)
      ssh.perform! "locale-gen #{locale} && update-locale LANG=#{locale}", options
    end

    def self.set_builtins(ssh, options)
      set ssh, ESCUALO_BASE_VERSION: Escualo::BASE_VERSION
      set ssh, Escualo::Env.locale_variables
      set ssh, Escualo::Env.environment_variables(options.env)
    end

    def self.list(ssh)
      ssh.exec!("cat ~/.escualo/vars/*").gsub("export ", '')
    end

    def self.clean(ssh, options)
      options.env = get(ssh, 'RACK_ENV').split('=').second.strip
      ssh.exec!("rm ~/.escualo/vars/*")
      set_builtins ssh, options
    end

    def self.present?(ssh, variable)
      value = get(ssh, variable)
      value.present?
    rescue
      false
    end

    def self.get(ssh, variable)
      ssh.exec!("cat ~/.escualo/vars/#{variable}")
    end

    def self.set(ssh, variables)
      variables.each do |key, value|
        ssh.exec!(set_command key, value)
      end
    end

    def self.set_command(key, value)
      "echo export #{key}=#{value} > ~/.escualo/vars/#{key}"
    end

    def self.unset(ssh, variable_names)
      variable_names.each do |name|
        ssh.exec!("rm ~/.escualo/vars/#{name}")
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