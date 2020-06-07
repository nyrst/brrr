require "dexter"
require "./structs/*"
require "./cli"

module Brrr
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  self.run
end
