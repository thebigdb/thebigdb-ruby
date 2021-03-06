require "spec_helper"

# Here's we're testing the basics of the module itself,
# the variable that you can set, the actions you can take, etc.

describe "TheBigDB module" do
  it "has accessors for common used global variables" do
    TheBigDB.api_host = "foobar"
    TheBigDB.api_port = 1337
    TheBigDB.api_version = "1337"
    TheBigDB.api_key = "your-private-api-key"
    TheBigDB.raise_on_api_status_error = true
    TheBigDB.before_request_execution = (before_proc = ->(request){ nil })
    TheBigDB.after_request_execution = (after_proc = ->(request){ nil })

    TheBigDB.api_host.should == "foobar"
    TheBigDB.api_port.should == 1337
    TheBigDB.api_version.should == "1337"
    TheBigDB.api_key.should == "your-private-api-key"
    TheBigDB.raise_on_api_status_error.should == true
    TheBigDB.before_request_execution.should == before_proc
    TheBigDB.after_request_execution.should == after_proc

    # use_ssl modifies the port
    TheBigDB.use_ssl = true
    TheBigDB.use_ssl.should == true
  end

  it "has resettable default values" do
    default_host = TheBigDB.api_host.dup
    TheBigDB.api_host = "foobar"
    TheBigDB.reset_default_configuration
    TheBigDB.api_host.should == default_host
  end

  it "can set a configuration scope" do
    TheBigDB.api_host = "thebigdb_host_1"
    TheBigDB.with_configuration(api_host: "thebigdb_host_2") do
      TheBigDB.api_host.should == "thebigdb_host_2"
    end
    TheBigDB.api_host.should == "thebigdb_host_1"
  end
end