require "yaml"

module Brrr
  struct BinaryType
    def self.binary
      "binary"
    end

    def self.mac_dmg
      "mac-dmg"
    end

    def self.tar
      "tar"
    end

    def self.zip
      "zip"
    end
  end

  struct PostInstallType
    def self.move
      "move"
    end

    def self.symlink
      "symlink"
    end
  end

  struct PostInstall
    include YAML::Serializable
    property type : String

    # Needed for move and symlink.
    property source : String
    property target : String
  end

  struct Binary
    include YAML::Serializable
    property binary_type : String
    property hash_sha1 : String?
    property hash_md5 : String?
    property post_install : Array(PostInstall)
    property url : String
  end

  struct Package
    include YAML::Serializable
    property brrr : String
    property latest_version : String
    property name : String
    property releases_feed : String
    property tags : Array(String)
    property url : String
    property versions : Hash(String, Hash(String, Binary))
  end
end
