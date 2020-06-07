require "yaml"

module Brrr
  struct Installation
    YAML.mapping(
      url: String,
      version: String
    )
  end

  struct BrrrConfig
    YAML.mapping(
      arch: String,
      installed: Hash(String, String | Installation)
    )
  end
end
