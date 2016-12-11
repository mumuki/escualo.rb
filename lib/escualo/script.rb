module Escualo
  module Script
    def self.commands(escualo, script, extra)
      (script||[]).map { |it| "#{escualo} #{it} #{extra}" }
    end

    def self.delegated_options(options)
      [options.hostname.try { |it| "--hostname #{it}" },
       options.username.try { |it| "--username #{it}" },
       options.password.try { |it| "--ssh-password #{it}" },
       options.ssh_key.try { |it| "--ssh-key #{it}" },
       options.ssh_port.try { |it| "--ssh-port #{it}" },
       options.trace && '--trace',
       options.verbose && '--verbose',
      ].compact.join(' ')
    end

    def self.run!(session, escualo, script, extra='')
      Escualo::Script.commands(escualo, script, extra).each do |command|
        session.embed! command
      end
    end
  end
end

