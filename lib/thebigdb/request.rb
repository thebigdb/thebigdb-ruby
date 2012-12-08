module TheBigDB
  class Request
    attr_reader :http, :http_request, :http_response

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

      if method == "get"
        encoded_params = URI.encode_www_form(params)
        @http_request = Net::HTTP::Get.new(request_uri + "?" + encoded_params)
      elsif method == "post"
        @http_request = Net::HTTP::Post.new(request_uri)
        @http_request.set_form_data(params)
      else
        raise ArgumentError, "The request method must be 'get' or 'post'"
      end

      @http_request["user-agent"] = "TheBigDB RubyWrapper/#{TheBigDB::VERSION::STRING}"

      client_user_agent = {
        :publisher => 'thebigdb',
        :version => TheBigDB::VERSION::STRING,
        :language => 'ruby',
        :language_version => "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})",
      }

      @http_request["X-TheBigDB-Client-User-Agent"] = JSON(client_user_agent)

      @http_request
    end

    # Actually makes the request prepared in @http_request, and sets @http_response
    def execute
      @http_response = @http.request(@http_request)
    end

    # Shortcut: returns Hash object from the HTTP response's JSON body
    def response
      # If the request hasn't been executed yet, we'll do it now
      unless defined?(@http_response)
        execute
      end

      # We then parse the JSON answer and return it.
      JSON(@http_response.body)
    end

    # Shortcut: prepares, executes and returns Hash containing the server's response
    def self.get_response(*args)
      request = new
      request.prepare(*args)
      request.execute
      request.response
    end
  end
end