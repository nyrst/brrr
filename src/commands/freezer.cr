require "../lib/common"
require "../structs/freezer"

module Brrr
  module Commands
    class Freezer
      def initialize(@config : Brrr::Config, args : Array(String))
        @repository = Repository.new @config.repository

        if args.size == 0
          Logger.start "Nothing to do."
          return
        end

        command = args[0]

        if command == "help"
          help
        elsif command == "generate"
          data = get_data
          build_apps(data)
          build_archs(data)
        else
          help
        end
      end

      def help
        Logger.log "Available commands: generate, help"
      end

      def get_data
        cwd = Dir.current

        folder = Path[cwd] / "data"
        if Dir.exists?(folder)
          FileUtils.rm_rf folder.to_s
        end

        Dir.mkdir folder

        entries = Dir.entries(cwd)
          .select { |e| e.ends_with? ".yaml" }
          .map do |e|
            yaml = Common.get_yaml(@repository, e).body

            if !yaml.nil?
              # Now, time to read the package and get some info
              Package.from_yaml(yaml)
            end
          end
          .reject(Nil)

        FreezerData.new(folder, entries)
      end

      private def build_apps(data : FreezerData)
        apps = data.entries
          .map { |e| to_hash(e, true) }

        File.write(data.folder / "apps.json", apps.to_json)
      end

      private def build_archs(data : FreezerData)
        ["linux", "macos", "macosarm"].map do |arch|
          apps = data.entries
            .select { |e| Common.get_archs(e.versions[e.latest_version], e.templates).includes? arch }
            .map { |e| to_hash(e, false) }

          File.write(data.folder / "apps-#{arch}.json", apps.to_json)
        end
      end

      private def to_hash(e : Package, includes_archs : Bool)
        item = Hash(String, String | Array(String)).new
        # item["brrr"] = e.brrr
        item["name"] = e.name
        item["latest_version"] = e.latest_version
        # item["tags"] = e.tags
        if includes_archs
          item["archs"] = Common.get_archs(e.versions[e.latest_version], e.templates)
        end
        item
      end

      private def generate_web_tags(folder : Path, entries : Array(Package))
        tags = entries
          .map { |e| e.tags }
          .reduce { |acc, e| acc + e }
          .uniq
          .sort

        File.write(folder / "tags.json", tags)

        tags_files = Hash(String, Array(Hash(String, String))).new
        tags.each do |t|
          tags_files[t] = entries
            .select { |e| e.tags.includes? t }
            .map do |e|
              item = Hash(String, String).new

              item["brrr"] = e.brrr
              item["latest_version"] = e.latest_version
              item["name"] = e.name

              item
            end
        end

        File.write(folder / "tags-files.json", tags_files.to_json)
      end
    end
  end
end
