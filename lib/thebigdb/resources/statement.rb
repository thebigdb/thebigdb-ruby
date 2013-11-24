module TheBigDB
  # Generic request to statements executor
  def self.Statement(action, params)
    method = ["get", "show", "search"].include?(action.to_s) ? "GET" : "POST"
    path = "/statements/#{action}"

    request = TheBigDB::Request.new
    request.prepare(method, path, params)
    request.execute
  end

  # Beautified builder
  class StatementRequest
    attr_reader :action, :params

    def initialize(action)
      @action = action
      @params = {}
      @response = nil
    end

    def with(params = {})
      @response = nil
      @params.merge!(TheBigDB::Helpers::stringify_keys(params))
      self
    end

    def method_missing(method_name, *arguments, &block)
      @response ||= TheBigDB::Statement(@action, @params).response
      @response.send(method_name, *arguments, &block)
    end

    def load
      to_hash # goes through method_missing
    end
    alias_method :response, :load
    alias_method :execute, :load

    def load! # forces the request to be re-loadd
      @response = nil
      to_hash
    end
    alias_method :execute!, :load!

    def inspect
      load.inspect
    end
  end

  # Shortcuts to actions
  def self.search(nodes = {})
    StatementRequest.new("search").with("nodes" => nodes)
  end

  def self.create(nodes = {})
    StatementRequest.new("create").with("nodes" => nodes)
  end

  def self.show(id = "")
    StatementRequest.new("show").with("id" => id)
  end

  def self.upvote(id = "")
    StatementRequest.new("upvote").with("id" => id)
  end

  def self.downvote(id = "")
    StatementRequest.new("downvote").with("id" => id)
  end
end