module Brrr
  class Logger
    def self.start(log : String)
      puts "⛄ #{log}"
    end

    def self.log(log : String)
      puts "❄️ #{log}"
    end

    def self.end(log : String)
      puts "☃️ #{log}"
    end
  end
end
