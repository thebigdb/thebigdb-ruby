module TheBigDB
  module Resources
    def self.User(action, params)
      method = "GET"
      path = "/users/#{action}"

      request = TheBigDB::Request.new
      request.prepare(method, path, params)
      request.execute
    end
  end
end