require "spec_helper"

# Here we're testing standard requests behaviour,
# what they send, what they receive,
# and how they incorporate them into this wrapper's objects.

describe "initializing requests" do
  before do
    @request = TheBigDB::Request.new
  end

  it "sets a http instance variable with correct attributes" do
    @request.http.address.should == TheBigDB.api_host
    @request.http.port.should == TheBigDB.api_port
  end
end

describe "preparing GET requests" do
  before do
    @request = TheBigDB::Request.new
    @request.prepare(:get, "/", :foo => "bar")
  end

  it "sets a http_request instance variable with correct attributes" do
    http_request = @request.http_request
    http_request.method == "GET"
    http_request.path.should == "/?foo=bar"
  end
end

describe "preparing POST requests" do
  before do
    @request = TheBigDB::Request.new
    @request.prepare(:post, "/", :foo => "bar")
  end

  it "sets a http_request instance variable with correct attributes" do
    http_request = @request.http_request
    http_request.method == "POST"
    http_request.path.should == "/"
    http_request.body.should == "foo=bar"
  end
end