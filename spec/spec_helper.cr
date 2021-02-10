ENV["BRRR_PATH"] = "/tmp/brrr"
ENV["BRRR_CACHE_PATH"] = "#{ENV["BRRR_PATH"]}/cache"
ENV["BRRR_CONFIG_PATH"] = "#{ENV["BRRR_PATH"]}/config"

require "http/server"
require "spec"

# require "../src/brrr"

def clear_brrr
  `rm -rf #{ENV["BRRR_PATH"]}`
end

def init_brrr
  `mkdir -p #{ENV["BRRR_PATH"]}`
end

def get_package_yaml
  yaml = <<-YAML
  name: "brrr"
  latest_version: 0.28657.144
  releases_feed: "https://github.com/nyrst/brrr/releases.atom"
  tags:
    - brrr
  url: "https://github.com/nyrst/brrr"
  versions:
    "0.28657.144":
      linux:
        post_install:
          -
            type: "symlink"
            source: "brrr"
            target: "brrr"
        binary_type: "tar"
        url: "https://github.com/nyrst/brrr/releases/download/v0.28657.144/brrr-linux.tar.gz"
  YAML

  yaml
end

def get_test_yaml_path
  init_brrr
  "#{ENV["BRRR_PATH"]}/test.yaml"
end

def create_yaml
  File.write(get_test_yaml_path, get_package_yaml)
end

def with_server
  server = HTTP::Server.new do |context|
    context.response.content_type = "text/plain"
    context.response.print get_package_yaml
  end

  address = server.bind_tcp 8080

  spawn do
    server.listen
  end

  yield

  server.close
end
