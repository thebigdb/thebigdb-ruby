module TheBigDB
  class Request
    class ApiStatusError < StandardError; end

    attr_reader :http, :http_request, :http_response, :data_sent, :data_received, :response

    # Prepares the basic @http object with the current values of the module (host, port, ...)
    def initialize
      @http = Net::HTTP.new(TheBigDB.api_host, TheBigDB.api_port)

      if TheBigDB.use_ssl
        @http.use_ssl = true
        if TheBigDB.verify_ssl_certificates
          raise NotImplementedError
        else
          @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end
    end

    # Prepares the @http_request object with the actual content of the request
    def prepare(method, request_uri, params = {})
      method = method.downcase.to_s

      # we add the API version to the URL, with a trailing slash and the rest of the request
      request_uri = "/v#{TheBigDB.api_version}" + (request_uri.start_with?("/") ? request_uri : "/#{request_uri}")

      if method == "get"
        encoded_params = TheBigDB::Helpers::serialize_query_params(params)
        @http_request = Net::HTTP::Get.new(request_uri + "?" + encoded_params)
      elsif method == "post"
        @http_request = Net::HTTP::Post.new(request_uri)
        @http_request.set_form_data(TheBigDB::Helpers::flatten_params_keys(params))
      else
        raise ArgumentError, "The request method must be 'get' or 'post'"
      end

      @http_request["user-agent"] = "TheBigDB RubyWrapper/#{TheBigDB::VERSION::STRING}"

      client_user_agent = {
        :publisher => "thebigdb",
        :version => TheBigDB::VERSION::STRING,
        :language => "ruby",
        :language_version => "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})",
      }

      @http_request["X-TheBigDB-Client-User-Agent"] = JSON(client_user_agent)

      self
    end

    # Actually makes the request prepared in @http_request, and sets @http_response
    def execute
      # Here is the order of operations:
      # -> setting @data_sent
      # -> executing before_request_execution callback
      # -> executing the HTTP request
      # -> setting @response
      # -> setting @data_received
      # -> executing after_request_execution callback

      # Setting @data_sent
      params = Rack::Utils.parse_nested_query(URI.parse(@http_request.path).query)
      # Since that's how it will be interpreted anyway on the server, we merge the POST params to the GET params,
      # but it's not supposed to happen: either every params is prepared for GET/query params, or as POST body
      params.merge!(Rack::Utils.parse_nested_query(@http_request.body.to_s))

      # About: Hash[{}.map{|k,v| [k, v.join] }]
      # it transforms the following hash:
      # {"accept"=>["*/*"], "user-agent"=>["TheBigDB RubyWrapper/X.Y.Z"], "host"=>["computer.host"]}
      # into the following hash:
      # {"accept"=>"*/*", "user-agent"=>"TheBigDB RubyWrapper/X.Y.Z", "host"=>"computer.host"}
      # which is way more useful and cleaner.
      @data_sent = {
        "headers" => Hash[@http_request.to_hash.map{|k,v| [k, v.join] }],
        "host" => @http.address,
        "port" => @http.port,
        "path" => URI.parse(@http_request.path).path,
        "method" => @http_request.method,
        "params" => params
      }

      # Executing callback
      TheBigDB.before_request_execution.call(self)

      # Here is where the request is actually executed
      @http_response = @http.request(@http_request)

      # Setting @response
      begin
        # We parse the JSON answer and return it.
        @response = JSON(@http_response.body)
      rescue JSON::ParserError => e
        @response = {"status" => "error", "error" => {"code" => "0000", "description" => "The server gave an invalid JSON body:\n#{@http_response.body}"}}
      end

      # Setting @data_received
      @data_received = {
        "headers" => Hash[@http_response.to_hash.map{|k,v| [k, v.join] }],
        "content" => @response
      }

      # Executing callback
      TheBigDB.after_request_execution.call(self)

      # Raising exception if asked
      if TheBigDB.raise_on_api_status_error and @response["status"] == "error"
        raise ApiStatusError.new(@response["error"]["code"])
      end

      self
    end

  end
end