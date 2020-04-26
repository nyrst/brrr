module Brrr
  module Commands
    class Version
      def self.run
        p "brrr v#{VERSION}"

        exit
      end
    end
  end
end
