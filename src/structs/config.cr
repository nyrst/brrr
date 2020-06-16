require "yaml"

module Brrr
  struct Installation
    include YAML::Serializable
    property url : String
    property version : String
  end

  struct BrrrConfig
    include YAML::Serializable
    property arch : String
    property installed : Hash(String, String | Installation)
  end
end
