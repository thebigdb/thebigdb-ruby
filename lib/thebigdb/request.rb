module TheBigDB
  class Request
    attr_reader :http, :http_request, :http_response

    # The request is prepared with the current values of the module (host, port, ...)
    # The request isn't actually made, @http_request is set
    def initialize(method, request_uri, params = {})
      method = method.downcase.to_s

      @http = Net::HTTP.new(::TheBigDB.api_host, ::TheBigDB.api_port)

      if ::TheBigDB.use_ssl
        @http.use_ssl = true
        if ::TheBigDB.verify_ssl_certificates
          raise NotImplementedError
        else
          @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end

      # fill params with more infos about the wrapper

      if method == "get"
        encoded_params = URI.encode_www_form(params)
        @http_request = Net::HTTP::Get.new(request_uri + "?" + encoded_params)
      elsif method == "post"
        @http_request = Net::HTTP::Post.new(request_uri)
        @http_request.set_form_data(params)
      else
        raise ArgumentError, "The request method must be 'get' or 'post'"
      end
    end

    # The request is executed and the @http_response is set
    def execute
      @http_response = @http.request(@http_request)
    end

    # This is the ruby Hash object response from the JSON answer
    def response
      # If the request hasn't been executed yet, we'll do it now
      unless defined?(@http_response)
        execute
      end

      # We then parse the JSON answer and return it.
      JSON(@http_response.body)
    end

    # shortcut
    def self.get_response(*args)
      request = new(*args)
      request.response
    end
  end
end