module TheBigDB
  def self.Statement(action, params)
    method = ["get", "show", "search"].include?(action.to_s) ? "GET" : "POST"
    path = "/statements/#{action}"

    request = TheBigDB::Request.new
    request.prepare(method, path, params)
    request.execute
  end
end