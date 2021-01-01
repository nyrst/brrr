module Brrr
  class Worker
    private def download_with_template(binary : WithTemplate, latest_version : String, cache_package_dir : Path, name : String, package : Package)
      templates = package.templates
      template_version = binary.use_template

      if templates.nil? || !templates.has_key?(template_version)
        Logger.log "Trying to read template #{template_version} but no `templates` found in package definition."
        return
      end

      binary = templates[template_version]
      le_hash = Hash(String, String).new
      le_hash["brrr_package_version"] = latest_version

      download_binaries(bidouille(binary, le_hash), cache_package_dir, name, package)
    end

    private def remove_with_template(binary : WithTemplate, installed_version : String, package_name : String, package : Package)
      templates = package.templates
      template_version = binary.use_template

      if templates.nil? || !templates.has_key?(template_version)
        Logger.log "Trying to read template #{template_version} but no `templates` found in package definition."
        return
      end

      binary = templates[template_version]
      le_hash = Hash(String, String).new
      le_hash["brrr_package_version"] = installed_version

      remove_binaries(bidouille(binary, le_hash), package_name)
    end
  end
end
