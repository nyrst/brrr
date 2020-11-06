module Brrr
  struct LightPackage
    include JSON::Serializable
    property latest_version : String
    property name : String

    def print(installed : String | Nil)
      if installed.nil?
        puts "#{@name}: #{@latest_version}"
      else
        puts "#{@name}: #{@latest_version} (installed: #{installed})"
      end
    end
  end
end
