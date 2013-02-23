require "spec_helper"

describe "Sentence" do
  context "basic request executing" do
    before do
      stub_request(:get, /#{TheBigDB.api_host}\/v#{TheBigDB.api_version}\/sentences\/search/).to_return(:body => '{"server_says": "hello world"}')

      @request = TheBigDB::Resources::Sentence(:search, nodes: ["a", "b"])
    end

    it "sets the correct data_sent instance variable" do
      @request.data_sent.should == {
          "headers" => Hash[@request.http_request.to_hash.map{|k,v| [k, v.join] }],
          "host" => TheBigDB.api_host,
          "port" => TheBigDB.api_port,
          "path" => "/v#{TheBigDB.api_version}/sentences/search",
          "method" => "GET",
          "params" => {"nodes" => {"0" => "a", "1" => "b"}}
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