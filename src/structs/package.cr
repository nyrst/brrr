require "json"
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
    def self.echo
      "echo"
    end

    def self.move
      "move"
    end

    def self.run
      "run"
    end

    def self.symlink
      "symlink"
    end
  end

  struct PostInstall
    include JSON::Serializable
    include YAML::Serializable
    property type : String

    # Needed for move and symlink.
    property source : String?
    property target : String?

    # For echo message
    property message : String?

    # For run command
    property command : String?
    property working_directory : String?
  end

  struct Binary
    include JSON::Serializable
    include YAML::Serializable
    property binary_type : String
    property hash_sha1 : String?
    property hash_md5 : String?
    property post_install : Array(PostInstall)
    property url : String
  end

  alias VersionId = String

  struct WithTemplate
    include JSON::Serializable
    include YAML::Serializable

    property use_template : VersionId
  end

  alias Arch = String
  alias Templates = Hash(VersionId, Hash(Arch, Binary | Array(Binary)))
  alias VersionBinary = Hash(Arch, Binary | Array(Binary))
  alias Version = WithTemplate | VersionBinary
  alias Versions = Hash(VersionId, Version)

  struct Package
    include JSON::Serializable
    include YAML::Serializable
    property brrr : String
    property brrr_version : String?
    property latest_version : String
    property name : String
    property releases_feed : String
    property tags : Array(String)
    property url : String
    property templates : Templates?
    property versions : Versions
  end
end
