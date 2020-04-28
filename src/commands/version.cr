module Brrr
  module Commands
    class Version
      def self.run
        puts "brrr v#{VERSION}"

        exit
      end
    end
  end
end
