require "yaml"

module Brrr
  struct Binary
    YAML.mapping(
      binary_type: String,
      hash_sha1: String?,
      hash_md5: String?,
      symlinks: Hash(String, String),
      url: String
    )
  end

  struct Package
    YAML.mapping(
      name: String,
      latest_version: String,
      url: String,
      versions: Hash(String, Hash(String, Binary))
    )
  end
end
