require "spec_helper"

# Here we're testing standard requests behaviour,
# what they send, what they receive,
# and how they incorporate them into this wrapper's objects.

describe "initializing GET requests" do
  before do
    @request = TheBigDB::Request.new(:get, "/", :foo => "bar")
  end

  it "sets a http instance variable with correct attributes" do
    @request.http.address.should == TheBigDB.api_host
    @request.http.port.should == TheBigDB.api_port
  end

end