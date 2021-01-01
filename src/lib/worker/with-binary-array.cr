module Brrr
  class Worker
    private def download_binaries(binaries : Array(Binary), cache_package_dir : Path, name : String, package : Package)
      binaries.each { |b| download_binaries(b, cache_package_dir, name, package) }
    end

    private def bidouille(binaries : Array(Binary), replacement : Hash(String, String))
      binaries.map { |b| bidouille(b, replacement) }
    end

    private def remove_binaries(binaries : Array(Binary), package_name : String)
      binaries.each { |b| remove_binaries(b, package_name) }
    end
  end
end
