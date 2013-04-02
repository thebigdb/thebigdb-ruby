require "spec_helper"

describe "Helpers" do
  describe "serialize_query_params" do
    it "works with simple a=b&c=d params" do
      TheBigDB::Helpers::serialize_query_params(a: "b", c: "d").should == "a=b&c=d"
    end

    it "works with more complex imbricated params" do
      same_expected_result = "house=brick%20and%20mortar&animals%5B0%5D=cat&animals%5B1%5D=dog&computers%5Bcool%5D=true&computers%5Bdrives%5D%5B0%5D=hard&computers%5Bdrives%5D%5B1%5D=flash"

      TheBigDB::Helpers::serialize_query_params({
        house: "brick and mortar",
        animals: ["cat", "dog"],
        computers: {cool: true, drives: ["hard", "flash"]}
      }).should == same_expected_result

      # and with a hash instead of an array
      TheBigDB::Helpers::serialize_query_params({
        house: "brick and mortar",
        animals: {"0" => "cat", "1" => "dog"},
        computers: {cool: true, drives: ["hard", "flash"]}
      }).should == same_expected_result
    end
  end

  describe "flatten_params_keys" do
    it "works with simple a=b&c=d params" do
      TheBigDB::Helpers::flatten_params_keys(a: "b", c: "d").should == {"a" => "b", "c" => "d"}
    end

    it "works with more complex imbricated params" do
      TheBigDB::Helpers::flatten_params_keys({
        house: "brick and mortar",
        animals: ["cat", "dog"],
        computers: {cool: true, drives: ["hard", "flash"]}
      }).should == {
        "house" => "brick and mortar",
        "animals[0]" => "cat",
        "animals[1]" => "dog",
        "computers[cool]" => "true",
        "computers[drives][0]" => "hard",
        "computers[drives][1]" => "flash"
      }

      # and with a hash instead of an array
      TheBigDB::Helpers::flatten_params_keys({
        house: "brick and mortar",
        animals: {"0" => "cat", "1" => "dog"},
        computers: {cool: true, drives: ["hard", "flash"]}
      }).should == {
        "house" => "brick and mortar",
        "animals[0]" => "cat",
        "animals[1]" => "dog",
        "computers[cool]" => "true",
        "computers[drives][0]" => "hard",
        "computers[drives][1]" => "flash"
      }
    end
  end

  describe "stringify_keys" do
    it "works with simple mixed hash" do
      TheBigDB::Helpers::stringify_keys({
        :a => "foo",
        "b" => "bar",
        "a" => "foo2"
      }).should == {
        "a" => "foo2",
        "b" => "bar"
      }
    end
  end
end