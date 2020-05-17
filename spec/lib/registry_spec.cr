require "../spec_helper"
require "../../src/lib/registry"

describe Brrr::Api do
  Spec.before_each do
    clear_brrr
    init_brrr
  end

  Spec.after_suite do
    clear_brrr
  end

  registry = Brrr::Api.new "http://127.0.0.1:8080/"

  describe "#get_package" do
    with_server do
      result = registry.get_package "brrr"
      result.should eq get_package_yaml
    end
  end

  describe "#is_local_package" do
    create_yaml

    registry.is_local_package(Path["something"]).should be_false
    registry.is_local_package(Path["something.yaml"]).should be_false
    registry.is_local_package(Path[get_test_yaml_path]).should be_true
  end
end
