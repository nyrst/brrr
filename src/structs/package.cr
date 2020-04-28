require "yaml"

module Brrr
  struct Binary
    YAML.mapping(
      binaries: Hash(String, String),
      binary_type: String,
      hash: String?,
      hash_type: String?,
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
