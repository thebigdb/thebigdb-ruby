require "spec_helper"

describe "Statement" do
  context "basic request executing" do
    before do
      stub_request(:get, @request_path.call("search")).to_return(:body => '{"server_says": "hello world"}')

      @request = TheBigDB::Statement(:search, nodes: ["a a", "b"])
    end

    it "sets the correct data_sent instance variable" do
      @request.data_sent.should == {
        "headers" => Hash[@request.http_request.to_hash.map{|k,v| [k, v.join] }],
        "host" => TheBigDB.api_host,
        "port" => TheBigDB.api_port,
        "path" => "/v#{TheBigDB.api_version}/statements/search",
        "method" => "GET",
        "params" => {"nodes" => {"0" => "a a", "1" => "b"}}
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

describe "StatementRequest" do
  before do
  end

  it "makes normal requests" do
    @search = TheBigDB.search("a a", "b", {match: "blue"})
    @search.with(page: 2)
    @search.params.should == {"nodes" => ["a a", "b", {match: "blue"}], "page" => 2}
  end

  it "cache the response unless the params are modified, or asked to" do
    stub_request(:get, @request_path.call("search")).to_return(:body => '{status: "success", statements: []}')

    response = TheBigDB.search("a", "b", {match: "blue"}).with(page: 2)
    response.execute
    response.execute

    response = TheBigDB.search("a", "b", {match: "red"}).with(page: 2)
    response.execute
    response.execute!

    a_request(:get, @request_path.call("search"))
      .with(query: hash_including({"nodes" => ["a", "b", {match: "blue"}], "page" => "2"})).should have_been_made.once

    a_request(:get, @request_path.call("search"))
      .with(query: hash_including({"nodes" => ["a", "b", {match: "red"}], "page" => "2"})).should have_been_made.times(2)
  end

  it "has standard actions correctly binded" do
    stub_request(:get, @request_path.call("search")).to_return(:body => '{status: "success", statements: []}')
    stub_request(:get, @request_path.call("show")).to_return(:body => '{status: "success"}')
    stub_request(:post, @request_path.call("create")).to_return(:body => '{status: "success"}')
    stub_request(:post, @request_path.call("upvote")).to_return(:body => '{status: "success"}')
    stub_request(:post, @request_path.call("downvote")).to_return(:body => '{status: "success"}')

    TheBigDB.search("a", "b", {match: "blue"}).execute
    TheBigDB.show("foobar").execute
    TheBigDB.create("foobar").execute
    TheBigDB.upvote("foobar").execute
    TheBigDB.downvote("foobar").execute

    a_request(:get, @request_path.call("search")).should have_been_made.once
    a_request(:get, @request_path.call("show")).should have_been_made.once
    a_request(:post, @request_path.call("create")).should have_been_made.once
    a_request(:post, @request_path.call("upvote")).should have_been_made.once
    a_request(:post, @request_path.call("downvote")).should have_been_made.once
  end

end