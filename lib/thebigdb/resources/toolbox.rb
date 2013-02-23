module TheBigDB
  module Resources
    module Toolbox
      def self.Units(action, params)
        method = "GET"
        path = "/toolbox/units/#{action}"

        request = TheBigDB::Request.new
        request.prepare(method, path, params)
        request.execute
      end
    end
  end
end