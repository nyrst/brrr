module Brrr
  module Script
    class Echo
      def initialize
      end

      def on_install(package : String, script : PostInstall)
        message = script.message

        if !message.nil?
          puts "\n  #{message}\n"
        end
      end
    end
  end
end
