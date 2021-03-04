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

    private def replace(from : String, replacement : Hash(String, String))
      to = from
      replacement.each do |key, value|
        to = to.gsub(key, value)
      end
      to
    end

    private def bidouille(binary : Binary, replacement : Hash(String, String))
      binary.post_install = binary.post_install.map do |p|
        # Needed for move and symlink.
        source = p.source
        if !source.nil?
          p.source = replace(source, replacement)
        end
        target = p.target
        if !target.nil?
          p.target = replace(target, replacement)
        end

        # For echo message
        message = p.message
        if !message.nil?
          p.message = replace(message, replacement)
        end

        # For run command
        command = p.command
        if !command.nil?
          p.command = replace(command, replacement)
        end
        working_directory = p.working_directory
        if !working_directory.nil?
          p.working_directory = replace(working_directory, replacement)
        end

        p
      end

      binary.url = replace(binary.url, replacement)

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
