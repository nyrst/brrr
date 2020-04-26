module Brrr
  class Cache
    home : Path
    getter path : Path

    def initialize
      @home = Path.home
      @path = @home / ".cache" / "brrr"

      if !Dir.exists? @path
        Dir.mkdir_p(@path, 0o755)
      end
    end
  end
end
