require "../lib/common"

module Brrr
  module Commands
    class Freezer
      def initialize(args : Array(String))
        @registry = Api.new nil

        if args.size == 0
          Logger.start "Nothing to do."
        end

        command = args[0]

        if command == "generate_web_data"
          generate_web_data
        else
          Logger.log "Available commands: help, generate_web_data"
        end
      end

      def generate_web_data
        cwd = Dir.current

        folder = Path[cwd] / "public"
        if Dir.exists?(folder)
          FileUtils.rm_rf folder.to_s
        end

        Dir.mkdir folder

        entries = Dir.entries(cwd)
          .select { |e| e.ends_with? ".yaml" }
          .map do |e|
            yaml = Common.get_yaml(@registry, e)

            if !yaml.nil?
              # Now, time to read the package and get some info
              Package.from_yaml(yaml)
            end
          end
          .reject(Nil)

        generate_apps(folder, entries)

        generate_web_tags(folder, entries)
      end

      private def generate_apps(folder : Path, entries : Array(Brrr::Package))
        apps = entries
          .map do |e|
            item = Hash(String, String | Array(String)).new
            item["brrr"] = e.brrr
            item["name"] = e.name
            item["latest_version"] = e.latest_version
            item["tags"] = e.tags
            item["arch"] = e.versions[e.latest_version].keys
            item
          end

        File.write(folder / "apps.json", apps.to_json)
      end

      private def generate_web_tags(folder : Path, entries : Array(Brrr::Package))
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
