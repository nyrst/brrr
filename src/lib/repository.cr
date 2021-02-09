require "halite"
require "./cache"

module Brrr
  struct RepositoryResult
    property url : String?
    property body : String?

    def initialize(@url : String?, @body : String?)
    end
  end

  class Repository
    @@DEFAULT_REPOSITORY = "http://nyrst.github.io/freezer/"

    property repository : String = @@DEFAULT_REPOSITORY

    def initialize(repository : String?)
      if !repository.nil?
        @repository = repository
      end
    end

    def get_arch(arch : String)
      url = get_arch_url arch

      r = Halite.follow.get(url)

      begin
        r.raise_for_status
        r.body
      rescue ex : Halite::ClientError | Halite::ServerError
        # puts "[#{ex.status_code}] #{ex.status_message} (#{ex.class})"
        nil
      end
    end

    def get_package(package : String)
      url = get_url package

      Log.debug { "Repository::get_package url: #{url}" }

      r = Halite.follow.get(url)

      begin
        r.raise_for_status
        RepositoryResult.new(url, r.body)
      rescue ex : Halite::ClientError | Halite::ServerError
        # puts "[#{ex.status_code}] #{ex.status_message} (#{ex.class})"
        RepositoryResult.new(url, nil)
      end
    end

    def get_arch_url(arch : String)
      "#{@repository}/data/apps-#{arch}.json"
    end

    def get_url(package : String)
      if is_distributed(package)
        package
      else
        "#{@repository}#{package}.yaml"
      end
    end

    def get_local_package(path : Path)
      content = File.open(path) do |file|
        file.gets_to_end
      end

      RepositoryResult.new(nil, content)
    end

    def is_local_package(path : Path)
      path.to_s.ends_with?(".yaml") && File.exists?(path)
    end

    def is_distributed(url : String)
      !url.starts_with?(@@DEFAULT_REPOSITORY) && url.starts_with?("https://")
    end
  end
end
