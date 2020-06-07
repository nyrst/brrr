require "halite"
require "./cache"

module Brrr
  class Api
    @@DEFAULT_REGISTRY = "http://nyrst.github.io/freezer/"

    property registry : String = @@DEFAULT_REGISTRY

    def initialize(registry : String?)
      # TODO Make this configurable, load from ~/.config/brrr/brrr.yaml
      if !registry.nil?
        @registry = registry
      end
    end

    def get_package(package : String)
      url = get_url package

      Log.debug { "Api::get_package url: #{url}" }

      r = Halite.follow.get(url)

      begin
        r.raise_for_status
        r.body
      rescue ex : Halite::ClientError | Halite::ServerError
        # puts "[#{ex.status_code}] #{ex.status_message} (#{ex.class})"
        nil
      end
    end

    def get_url(package : String)
      if is_distributed(package)
        package
      else
        "#{@registry}#{package}.yaml"
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

    def is_distributed(url : String)
      !url.starts_with?(@@DEFAULT_REGISTRY) && url.starts_with?("https://")
    end
  end
end
