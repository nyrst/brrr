require "./structs/*"
require "./cli"
require "./lib/log"

module Brrr
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  self.run
end
