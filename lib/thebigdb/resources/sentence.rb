module TheBigDB
  def self.Sentence(action, params)
    method = ["get", "show", "search"].include?(action.to_s) ? "GET" : "POST"
    path = "/sentences/#{action}"

    request = TheBigDB::Request.new
    request.prepare(method, path, params)
    request.execute
  end
end