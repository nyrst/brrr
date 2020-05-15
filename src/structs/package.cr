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
    YAML.mapping(
      type: String,

      # Needed for move and symlink.
      source: String,
      target: String
    )
  end

  struct Binary
    YAML.mapping(
      binary_type: String,
      hash_sha1: String?,
      hash_md5: String?,
      post_install: Array(PostInstall),
      url: String
    )
  end

  struct Package
    YAML.mapping(
      brrr: String,
      latest_version: String,
      name: String,
      releases_feed: String,
      tags: Array(String),
      url: String,
      versions: Hash(String, Hash(String, Binary))
    )
  end
end
