module Brrr
  class PackageNotFound
    def self.log(package_name : String, registry : String)
      puts "❄️ #{package_name} not found on #{registry}."
    end
  end
end
