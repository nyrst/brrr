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
    property repository : String?
    property installed : Hash(String, Installation)
  end
end
