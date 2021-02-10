require "../lib/common"
require "../structs/repository"

module Brrr
  module Commands
    class List
      def initialize(@config : Brrr::Config)
        @repository = Repository.new @config.repository
        arch = @config.arch

        if arch.nil?
          puts "Please configure your arch first:"
          puts "  brrr config set arch <value>"
          puts "  <value> can be linux, macos, macosarm"
          exit
        end

        run
      end

      protected def get_version(installation : Installation)
        installation.version
      end

      protected def run
        response = @repository.get_arch(@config.arch)

        if !response.nil?
          data = Array(LightPackage).from_json response

          to_install = Array(String).new

          data
            .sort { |a, b| a.name <=> b.name }
            .each do |p|
              installed = if @config.installed.has_key? p.name
                            @config.installed[p.name]
                          else
                            nil
                          end

              installed_version = if installed.nil?
                                    nil
                                  else
                                    get_version installed
                                  end

              p.print(installed_version)

              if installed_version && Common.can_upgrade(p.latest_version, installed_version)
                to_install << p.name
              end
            end

          if to_install.size > 0
            puts ""
            puts "The following modules have newer versions available:"
            puts to_install.join ","
            puts "Run `brrr up` to upgrade them"
          end
        else
          puts "List for #{@config.arch} not found"
        end
      end
    end
  end
end
