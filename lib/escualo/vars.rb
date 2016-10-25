module Escualo
  module Vars
    def self.setup(ssh)
      source_escualorc = "'source ~/.escualorc'"
      ssh.exec! "mkdir -p ~/.escualo/vars"
      ssh.exec! "echo 'for var in ~/.escualo/vars/*; do source $var; done' > ~/.escualorc"
      ssh.exec! "chmod u+x ~/.escualorc"
      ssh.exec! "grep -q #{source_escualorc} ~/.bashrc || echo #{source_escualorc} >> ~/.bashrc"
    end

    def self.set_builtins(ssh)
      set ssh, ESCUALO_BASE_VERSION: Escualo::BASE_VERSION
      set ssh, Escualo::Vars.locale_variables
      set ssh, Escualo::Vars.production_variables
    end

    def self.list(ssh)
      ssh.exec!("cat ~/.escualo/vars/*").gsub("export ", '')
    end

    def self.clean(ssh)
      ssh.exec!("rm ~/.escualo/vars/*")
      set_builtins ssh
    end

    def self.present?(ssh, variable)
      ssh.exec!("cat ~/.escualo/vars/#{variable}").present?
    end

    def self.set(ssh, variables)
      variables.each do |key, value|
        ssh.exec!("echo 'export #{key}=#{value}' > ~/.escualo/vars/#{key}")
      end
    end

    def self.unset(ssh, variable_names)
      variable_names.each do |name|
        ssh.exec!("rm ~/.escualo/vars/#{name}")
      end
    end

    def self.locale_variables
      %w{LANG LC_ALL LC_NAME LC_PAPER LC_ADDRESS LC_NUMERIC LC_MONETARY LC_TELEPHONE LC_MEASUREMENT}.map do |it|
        [it, 'en_US.UTF-8']
      end.to_h
    end

    def self.production_variables
      %w{RAILS_ENV NODE_ENV RACK_ENV}.map do |it|
        [it, 'production']
      end.to_h
    end

    def self.locale_export
      locale_variables.map { |key, value| "#{key}=#{value}" }.join(' ')
    end
  end
end