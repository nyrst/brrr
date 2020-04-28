require "yaml"

module Brrr
  struct BrrrConfig
    YAML.mapping(
      arch: String,
      installed: Hash(String, String)
    )
  end
end
