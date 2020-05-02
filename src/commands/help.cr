module Brrr
  module Commands
    class Help
      def self.run
        puts <<-HELP
      brrr <command> [<options>]

      Basic commands:

        config
          list                      List the current configuration options.
          set <key> <value>         Set a configuration option.
        install <package names>     Install a package.
        upgrade <package names>     Upgrade everything or specific packages.
        uninstall <package names>   Uninstall packages.

      Utility commands:

        cache
          clean                     Clean the cache of unused packages.
        doctor                      Check the sanity of your installed packages.
        help                        Show help.
        version                     Print the current version of brrr.
     HELP

        exit 0
      end
    end
  end
end
