require "file_utils"
require "halite"

module Brrr
  class Downloader
    def self.get_file(url : String, target : Path)
      response = HTTP::Client.get url

      Halite.follow.get(url) do |response|
        # TODO response.status_code  # => 200
        File.write(target, response.body_io)
      end
    end

    def self.verify(path : Path, binary : Binary)
      file = File.new(path)
      content = file.gets_to_end

      result = true
      if !binary.hash_sha1.nil? && Digest::SHA1.hexdigest(content) != binary.hash_sha1
        result = false
      end
      if !binary.hash_md5.nil? && Digest::MD5.hexdigest(content) != binary.hash_md5
        result = false
      end

      file.close

      result
    end

    def self.extract(cache_path : Path, binary : Brrr::Binary, target_path : Path)
      puts "Extract #{cache_path} to #{target_path}"

      if !Dir.exists? target_path
        Dir.mkdir_p(target_path, 0o755)
      end

      case binary.binary_type
      when "binary"
        FileUtils.cp([cache_path.to_s], target_path.to_s)
      when "tar"
        output = `tar xf #{cache_path} -C #{target_path}`
      when "zip"
        output = `unzip #{cache_path} -d #{target_path}`
      end
    end
  end
end
