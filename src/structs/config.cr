require "yaml"

module Brrr
  struct BrrrConfig
    YAML.mapping(
      arch: String,
    )
  end
end
