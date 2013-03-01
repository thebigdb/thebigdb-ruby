require "spec_helper"

describe "User" do
  context "basic request executing" do
    before do
      stub_request(:get, /#{TheBigDB.api_host}\/v#{TheBigDB.api_version}\/users\/show/).to_return(:body => '{"server_says": "hello world"}')

      @request = TheBigDB::User(:show, login: "christophe")
    end

    it "sets the correct data_sent instance variable" do
      @request.data_sent.should == {
          "headers" => Hash[@request.http_request.to_hash.map{|k,v| [k, v.join] }],
          "host" => TheBigDB.api_host,
          "port" => TheBigDB.api_port,
          "path" => "/v#{TheBigDB.api_version}/users/show",
          "method" => "GET",
          "params" => {"login" => "christophe"}
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