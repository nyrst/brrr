require "../spec_helper"
require "../../src/lib/repository"

describe Brrr::Repository do
  Spec.before_each do
    clear_brrr
    init_brrr
  end

  Spec.after_suite do
    clear_brrr
  end

  repository = Brrr::Repository.new "http://127.0.0.1:8080/"

  describe "#get_package" do
    with_server do
      result = repository.get_package "brrr"
      result.body.should eq get_package_yaml
    end
  end

  describe "#is_local_package" do
    create_yaml

    repository.is_local_package(Path["something"]).should be_false
    repository.is_local_package(Path["something.yaml"]).should be_false
    repository.is_local_package(Path[get_test_yaml_path]).should be_true
  end
end
