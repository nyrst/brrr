module Brrr
  module Commands
    class Help
      def self.run
        puts <<-HELP
     brrr [<command>] [<options>]

     Commands:
         install   Install something.
         help      Show help.
         version   Print the current version of brrr.
     HELP

        exit 0
      end
    end
  end
end
