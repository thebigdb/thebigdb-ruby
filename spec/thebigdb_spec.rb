require "spec_helper"

# Here's we're testing the basics of the module itself,
# the variable that you can set, the actions you can take, etc.

describe "TheBigDB module" do
  it "has accessors for common used global variables" do
    TheBigDB.api_host = "foobar"
    TheBigDB.api_port = 1337
    TheBigDB.api_version = "1337"

    TheBigDB.api_host.should == "foobar"
    TheBigDB.api_port.should == 1337
    TheBigDB.api_version.should == "1337"
  end

  it "has resettable default values" do
    default_host = TheBigDB.api_host.dup
    TheBigDB.api_host = "foobar"
    TheBigDB.reset_default_configuration
    TheBigDB.api_host.should == default_host
  end
end