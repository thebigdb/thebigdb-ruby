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

describe "preparing" do
  context "GET requests" do
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

  context "POST requests" do
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
end

describe "executing" do

  context "requests" do
    before do
      stub_request(:get, /#{TheBigDB.api_host}/).to_return(:body => '{"server_says": "hello world"}')

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

  context "requests with before/after callbacks" do
    it "runs both of them" do
      stub_request(:get, /#{TheBigDB.api_host}/).to_return(:body => "{}")

      String.should_receive(:new).with("called in before_execution")
      String.should_receive(:new).with("called in after_execution")

      TheBigDB.before_request_execution = proc { String.new("called in before_execution") }
      TheBigDB.after_request_execution = proc { String.new("called in after_execution") }

      TheBigDB.send_request(:get, "/")
    end
  end

  context "failing requests" do
    it "can raise an exception" do
      stub_request(:get, /#{TheBigDB.api_host}/).to_return(:body => "invalid json")

      TheBigDB.raise_on_api_status_error = true
      lambda { TheBigDB.send_request(:get, "/") }.should raise_error(TheBigDB::Request::ApiStatusError, "0000")
    end
  end

  context "GET requests" do
    context "with basic params" do
      before do
        stub_request(:get, /#{TheBigDB.api_host}/).to_return(:body => '{"server_says": "hello world"}')

        @request = TheBigDB::Request.new
        @request.prepare(:get, "/", :foo => "bar")
        @request.execute
      end

      it "sets the correct data_sent instance variable" do
        @request.data_sent.should == {
            "headers" => Hash[@request.http_request.to_hash.map{|k,v| [k, v.join] }],
            "host" => TheBigDB.api_host,
            "port" => TheBigDB.api_port,
            "path" => "/v#{TheBigDB.api_version}/",
            "method" => "GET",
            "params" => {"foo" => "bar"}
          }
      end

      it "sets the correct data_received instance variable" do
        @request.data_received.should include({
            "headers" => Hash[@request.http_response.to_hash.map{|k,v| [k, v.join] }],
            "content" => {"server_says" => "hello world"}
          })
      end
    end

    context "with arrays in params" do
      before do
        stub_request(:get, /#{TheBigDB.api_host}/).to_return(:body => '{"server_says": "hello world"}')

        @request = TheBigDB::Request.new
        @request.prepare(:get, "/", :nodes => ["foo", "bar"])
        @request.execute
      end

      it "sets the correct data_sent instance variable" do
        @request.data_sent.should == {
            "headers" => Hash[@request.http_request.to_hash.map{|k,v| [k, v.join] }],
            "host" => TheBigDB.api_host,
            "port" => TheBigDB.api_port,
            "path" => "/v#{TheBigDB.api_version}/",
            "method" => "GET",
            "params" => {"nodes" => {"0" => "foo", "1" => "bar"}}
          }
      end

      it "sets the correct data_received instance variable" do
        @request.data_received.should include({
            "headers" => Hash[@request.http_response.to_hash.map{|k,v| [k, v.join] }],
            "content" => {"server_says" => "hello world"}
          })
      end
    end

    context "with hashes in params" do
      before do
        stub_request(:get, /#{TheBigDB.api_host}/).to_return(:body => '{"server_says": "hello world"}')

        @request = TheBigDB::Request.new
        @request.prepare(:get, "/", :nodes => {"0" => "foo", "1" => "bar"})
        @request.execute
      end

      it "sets the correct data_sent instance variable" do
        @request.data_sent.should == {
            "headers" => Hash[@request.http_request.to_hash.map{|k,v| [k, v.join] }],
            "host" => TheBigDB.api_host,
            "port" => TheBigDB.api_port,
            "path" => "/v#{TheBigDB.api_version}/",
            "method" => "GET",
            "params" => {"nodes" => {"0" => "foo", "1" => "bar"}}
          }
      end

      it "sets the correct data_received instance variable" do
        @request.data_received.should include({
            "headers" => Hash[@request.http_response.to_hash.map{|k,v| [k, v.join] }],
            "content" => {"server_says" => "hello world"}
          })
      end
    end
  end

  context "POST requests" do
    context "with basic params" do
      before do
        stub_request(:post, /#{TheBigDB.api_host}/).to_return(:body => '{"server_says": "hello world"}')

        @request = TheBigDB::Request.new
        @request.prepare(:post, "/", :foo => "bar")
        @request.execute
      end

      it "sets the correct data_sent instance variable" do
        @request.data_sent.should == {
            "headers" => Hash[@request.http_request.to_hash.map{|k,v| [k, v.join] }],
            "host" => TheBigDB.api_host,
            "port" => TheBigDB.api_port,
            "path" => "/v#{TheBigDB.api_version}/",
            "method" => "POST",
            "params" => {"foo" => "bar"}
          }
      end

      it "sets the correct data_received instance variable" do
        @request.data_received.should include({
            "headers" => Hash[@request.http_response.to_hash.map{|k,v| [k, v.join] }],
            "content" => {"server_says" => "hello world"}
          })
      end
    end

    context "with array arguments" do
      before do
        stub_request(:post, /#{TheBigDB.api_host}/).to_return(:body => '{"server_says": "hello world"}')

        @request = TheBigDB::Request.new
        @request.prepare(:post, "/", :nodes => ["foo", "bar"])
        @request.execute
      end

      it "sets the correct data_sent instance variable" do
        @request.data_sent.should == {
            "headers" => Hash[@request.http_request.to_hash.map{|k,v| [k, v.join] }],
            "host" => TheBigDB.api_host,
            "port" => TheBigDB.api_port,
            "path" => "/v#{TheBigDB.api_version}/",
            "method" => "POST",
            "params" => {"nodes" => {"0" => "foo", "1" => "bar"}}
          }
      end

      it "sets the correct data_received instance variable" do
        @request.data_received.should include({
            "headers" => Hash[@request.http_response.to_hash.map{|k,v| [k, v.join] }],
            "content" => {"server_says" => "hello world"}
          })
      end
    end

    context "with hash arguments" do
      before do
        stub_request(:post, /#{TheBigDB.api_host}/).to_return(:body => '{"server_says": "hello world"}')

        @request = TheBigDB::Request.new
        @request.prepare(:post, "/", :nodes => {"0" => "foo", "1" => "bar"})
        @request.execute
      end

      it "sets the correct data_sent instance variable" do
        @request.data_sent.should == {
            "headers" => Hash[@request.http_request.to_hash.map{|k,v| [k, v.join] }],
            "host" => TheBigDB.api_host,
            "port" => TheBigDB.api_port,
            "path" => "/v#{TheBigDB.api_version}/",
            "method" => "POST",
            "params" => {"nodes" => {"0" => "foo", "1" => "bar"}}
          }
      end

      it "sets the correct data_received instance variable" do
        @request.data_received.should include({
            "headers" => Hash[@request.http_response.to_hash.map{|k,v| [k, v.join] }],
            "content" => {"server_says" => "hello world"}
          })
      end
    end
  end
end

describe "Request helper" do
  describe "serialize_query_params" do
    it "works with simple a=b&c=d params" do
      TheBigDB::Request.serialize_query_params(a: "b", c: "d").should == "a=b&c=d"
    end

    it "works with more complex imbricated params" do
      TheBigDB::Request.serialize_query_params({
        house: "bricks",
        animals: ["cat", "dog"],
        computers: {cool: true, drives: ["hard", "flash"]}
      }).should == "house=bricks&animals%5B0%5D=cat&animals%5B1%5D=dog&computers%5Bcool%5D=true&computers%5Bdrives%5D%5B0%5D=hard&computers%5Bdrives%5D%5B1%5D=flash"

      # and with a hash instead of an array
      TheBigDB::Request.serialize_query_params({
        house: "bricks",
        animals: {"0" => "cat", "1" => "dog"},
        computers: {cool: true, drives: ["hard", "flash"]}
      }).should == "house=bricks&animals%5B0%5D=cat&animals%5B1%5D=dog&computers%5Bcool%5D=true&computers%5Bdrives%5D%5B0%5D=hard&computers%5Bdrives%5D%5B1%5D=flash"
    end
  end

  describe "flatten_params_keys" do
    it "works with simple a=b&c=d params" do
      TheBigDB::Request.flatten_params_keys(a: "b", c: "d").should == {"a" => "b", "c" => "d"}
    end

    it "works with more complex imbricated params" do
      TheBigDB::Request.flatten_params_keys({
        house: "bricks",
        animals: ["cat", "dog"],
        computers: {cool: true, drives: ["hard", "flash"]}
      }).should == {
        "house" => "bricks",
        "animals[0]" => "cat",
        "animals[1]" => "dog",
        "computers[cool]" => "true",
        "computers[drives][0]" => "hard",
        "computers[drives][1]" => "flash"
      }

      # and with a hash instead of an array
      TheBigDB::Request.flatten_params_keys({
        house: "bricks",
        animals: {"0" => "cat", "1" => "dog"},
        computers: {cool: true, drives: ["hard", "flash"]}
      }).should == {
        "house" => "bricks",
        "animals[0]" => "cat",
        "animals[1]" => "dog",
        "computers[cool]" => "true",
        "computers[drives][0]" => "hard",
        "computers[drives][1]" => "flash"
      }
    end
  end
end

