module Brrr
  module Commands
    class Help
      def self.run
        puts <<-HELP
      brrr [<command>] [<options>]

      Commands:
        cache
          clean                     To clean the cache of unused packages.
        config
          list                      To list the current configuration options.
          set <key> <value>         To set a configuration option.
        install <package names>     Install a package.
        help                        Show help.
        upgrade <package names>     Upgrade everything or specific packages.
        uninstall <package names>   Uninstall packages.
        version                     Print the current version of brrr.
     HELP

        exit 0
      end
    end
  end
end
