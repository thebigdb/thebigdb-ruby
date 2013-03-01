module TheBigDB
  module Toolbox
    def self.Unit(action, params)
      method = "GET"
      path = "/toolbox/units/#{action}"

      request = TheBigDB::Request.new
      request.prepare(method, path, params)
      request.execute
    end
  end
end