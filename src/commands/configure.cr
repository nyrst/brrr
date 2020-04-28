module Brrr
  module Commands
    class Configure
      def self.run(config : Brrr::Config, args : Array(String))
        if args.size == 0
          puts "`brrr config` needs some options."
          Commands::Help.run
          return
        end

        command = args[0]

        if command == "list"
          config.list
        elsif command == "set"
          if args.size != 3
            puts "`brrr config set` should be called with a `key` and a `value`."
            exit 0
          end

          config.set(args[1], args[2])
        end
      end
    end
  end
end