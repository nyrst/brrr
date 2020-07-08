require "../spec_helper"
require "../../src/lib/cache"

describe Brrr::Cache do
  Spec.after_suite do
    clear_brrr
  end

  describe "#initialize" do
    it "should work" do
      env_cache_dir = Path[ENV["BRRR_CACHE_PATH"]]
      Brrr::Cache.new

      Dir.exists?(env_cache_dir).should be_true
    end
  end

  describe "#get_all_packages" do
    it "should be empty when there are no packages" do
      cache = Brrr::Cache.new
      cache.get_all_packages.should be_empty
    end

    it "should return a package name when present" do
      cache = Brrr::Cache.new
      # Let say we have a package
      `mkdir -p #{ENV["BRRR_CACHE_PATH"]}/brrr`
      cache.get_all_packages.should eq ["brrr"]
    end
  end

  describe "#read_yaml" do
    cache = Brrr::Cache.new

    it "should work for a weird value" do
      cache.read_yaml("weird value").should be_nil
    end
  end

  describe "#uninstall" do
    it "should work" do
      env_cache_dir = Path[ENV["BRRR_CACHE_PATH"]]
      cache = Brrr::Cache.new
      cache.uninstall "brrr"
      Dir.exists?("#{env_cache_dir}/brrr").should be_false
    end
  end
end
