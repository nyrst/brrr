require "./*"

module Brrr
  class Worker
    def initialize(@config : Config)
    end

    def download(version : WithTemplate | VersionBinary, latest_version : String, cache_package_dir : Path, name : String, package : Package)
      if version.is_a?(WithTemplate)
        v = version.as(WithTemplate)
        download_with_template(v, latest_version, cache_package_dir, name, package)
      elsif version.is_a?(VersionBinary)
        v = version.as(VersionBinary)
        download_binaries(v[@config.arch], cache_package_dir, name, package)
      else
        puts "Can't work with #{version}"
      end
    end

    def remove(version : WithTemplate | VersionBinary, installed_version : String, name : String, package : Package)
      if version.is_a?(WithTemplate)
        v = version.as(WithTemplate)
        remove_with_template(v, installed_version, name, package)
      elsif version.is_a?(VersionBinary)
        v = version.as(VersionBinary)
        remove_binaries(v[@config.arch], name)
      else
        puts "Can't work with #{version}"
      end
    end

    private def bidouille(binaries : Hash(String, Array(Binary) | Binary), replacement : Hash(String, String))
      bidouille(binaries[@config.arch], replacement)
    end
  end
end
