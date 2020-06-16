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
        info <package names>        Show information about a package.
        install <package names>     Install a package (aliases: add, i).
        outdated                    Show installed packages and new available versions.
        upgrade <package names>     Upgrade everything or specific packages (alias: up).
        uninstall <package names>   Uninstall packages (aliases: remove, rm, u).

      Utility commands:

        cache
          clean                     Clean the cache of unused packages.
        doctor                      Check the sanity of your installed packages.
        help                        Show help (alias: h)
        version                     Print the current version of brrr (alias: v).
     HELP

        exit 0
      end
    end
  end
end
