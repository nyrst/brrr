require "halite"
require "./cache"

module Brrr
  class Api
    property registry : String = "http://nyrst.github.io/freezer/"

    def initialize(registry : String?)
      if !registry.nil?
        @registry = registry
      end
    end

    def get_package(package : String)
      r = Halite.follow.get("#{@registry}#{package}.yaml")

      begin
        r.raise_for_status
        r.body
      rescue ex : Halite::ClientError | Halite::ServerError
        # puts "[#{ex.status_code}] #{ex.status_message} (#{ex.class})"
        nil
      end
    end

    def get_local_package(path : Path)
      content = File.open(path) do |file|
        file.gets_to_end
      end

      content
    end

    def is_local_package(path : Path)
      path.to_s.ends_with?(".yaml") && File.exists?(path)
    end
  end
end
