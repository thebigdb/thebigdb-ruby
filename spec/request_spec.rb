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
    @request.prepare(:get, "/abc", :foo => "bar")
  end

  it "sets a http_request instance variable with correct attributes" do
    http_request = @request.http_request
    http_request.method == "GET"
    http_request.path.should == "/v#{TheBigDB.api_version}/abc?foo=bar"
  end
end

describe "preparing POST requests" do
  before do
    @request = TheBigDB::Request.new
    @request.prepare(:post, "/abc", :foo => "bar")
  end

  it "sets a http_request instance variable with correct attributes" do
    http_request = @request.http_request
    http_request.method == "POST"
    http_request.path.should == "/v#{TheBigDB.api_version}/abc"
    http_request.body.should == "foo=bar"
  end
end

describe "executing requests" do
  before do
    stub_request(:any, /#{TheBigDB.api_host}/).to_return(:body => '{"server_says": "hello world"}')

    @request = TheBigDB::Request.new
    @request.prepare(:get, "/", :foo => "bar")
    @request.execute
  end

  it "sends the correct HTTP request" do
    a_request(:get, /#{TheBigDB.api_host}/).with(:query => {"foo" => "bar"}).should have_been_made
  end

  it "sets the correct http_response object" do
    @request.http_response.body.should == '{"server_says": "hello world"}'
  end

  it "sets the correct response Hash" do
    @request.response.should == {"server_says" => "hello world"}
  end
end