require "../spec_helper"
require "../../src/lib/common"

describe Brrr::Common do
  Spec.after_suite do
    clear_brrr
  end

  describe "#can_upgrade" do
    it "should work with semantic version" do
      Brrr::Common.can_upgrade("1.0.0", "1.0.0").should be_false
      Brrr::Common.can_upgrade("1.0.0", "2.0.0").should be_false
      Brrr::Common.can_upgrade("2.0.0", "1.0.0").should be_true
    end

    it "should work with other version styles" do
      Brrr::Common.can_upgrade("2020", "2020").should be_false
      Brrr::Common.can_upgrade("2019", "2020").should be_false
      Brrr::Common.can_upgrade("2020", "2019").should be_true
    end
  end

  describe "#save_yaml" do
    it "should save" do
      cache_package_dir = Path[ENV["BRRR_CACHE_PATH"]]
      name = "brrr"
      yaml = "brrr: plop"

      Brrr::Common.save_yaml(cache_package_dir, name, yaml)

      File.exists?("#{cache_package_dir}/#{name}.yaml").should be_true
    end
  end
end
