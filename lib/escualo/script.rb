module Escualo
  module Script
    def self.each_command(script, extra='', &block)
      script.map { |it| "escualo #{it} #{extra}" }.each(&block) if script
    end
  end
end

