module Brrr
  class Worker
    private def download_binaries(binary : Binary, cache_package_dir : Path, name : String, package : Package)
      cache_target_path = download_and_get_target(binary.url, cache_package_dir)

      # Let's verify the hash (check if present is in the `verify` function)
      if !Downloader.verify(cache_target_path, binary)
        Logger.log "Failed to verify checksum for file #{cache_target_path}."
        return
      end

      # Then we can extract from the cache to our packages folder
      Downloader.extract(cache_target_path, binary, @config.packages_path / name)

      if binary.post_install
        @config.post_install(name, binary.post_install)
      end
    end

    private def bidouille(binary : Binary, replacement : Hash(String, String))
      url = binary.url

      replacement.each do |key, value|
        url = url.gsub(key, value)
      end

      # TODO replace version in scripts (symlink/move)

      binary.url = url
      binary
    end

    private def download_and_get_target(url : String, cache_package_dir : Path)
      start_index = (url.rindex("/") || 0) + 1
      binary_name = url[start_index..-1]
      cache_target_path = cache_package_dir / binary_name
      Downloader.get_file(url, cache_target_path)

      cache_target_path
    end

    private def remove_binaries(binary : Binary, package_name : String)
      @config.uninstall(package_name, binary)
    end
  end
end
