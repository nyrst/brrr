require "file_utils"

module Brrr
  module Commands
    class Reset
      def initialize(@config : Brrr::Config, @cache : Brrr::Cache)
        installed_packages = @config.installed.keys

        Commands::Uninstall.new(@config, cache, installed_packages)
      end
    end
  end
end
