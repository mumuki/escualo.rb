module Escualo
  module Script
    def self.each_command(script, extra='', &block)
      script.map { |it| "escualo #{it} #{extra}" }.each(&block) if script
    end

    def self.delegated_options(options)
      [options.hostname.try { |it| "--hostname #{it}" },
       options.username.try { |it| "--username #{it}" },
       options.password.try { |it| "--ssh-password #{it}" },
       options.ssh_key.try { |it| "--ssh-key #{it}" },
       options.ssh_port.try { |it| "--ssh-port #{it}" },
       options.trace && '--trace',
       options.verbose && '--verbose'
      ].compact.join(' ')
    end

    def self.run!(session, script, extra='')
      Escualo::Script.each_command script, extra do |command|
        session.tell! command
      end
    end
  end
end

