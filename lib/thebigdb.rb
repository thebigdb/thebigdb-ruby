require "net/https"
require "json"
require "rack"

%w(
  module_attribute_accessors
  aliases
  request
  version
  resources/statement
  resources/user
  resources/toolbox
).each do |file_name|
  require File.join(File.dirname(__FILE__), 'thebigdb', file_name)
end

module TheBigDB

  DEFAULT_CONFIGURATION = {
    "api_host" => "api.thebigdb.com",
    "api_port" => 80,
    "api_version" => "1",
    "use_ssl" => false,
    "verify_ssl_certificates" => false,
    "before_request_execution" => Proc.new{},
    "after_request_execution" => Proc.new{}
  }

  DEFAULT_CONFIGURATION.each_key do |configuration_key|
    mattr_accessor configuration_key
  end

  def self.reset_default_configuration
    DEFAULT_CONFIGURATION.each_pair do |key, value|
      send(key + "=", value)
    end
  end
  reset_default_configuration

  def self.use_ssl=(bool)
    @@api_port = bool ? 443 : 80
    @@use_ssl = bool
  end

  def self.verify_ssl_certificates=(bool)
    if bool
      raise NotImplementedError, "The certificates are never checked"
    end
    @@verify_ssl_certificates = bool
  end

  def self.before_request_execution=(object)
    unless object.is_a?(Proc)
      raise ArgumentError, "You must pass a proc or lambda"
    end
    @@before_request_execution = object
  end

  def self.after_request_execution=(object)
    unless object.is_a?(Proc)
      raise ArgumentError, "You must pass a proc or lambda"
    end
    @@after_request_execution = object
  end


  # Shortcut: prepares, executes and returns Hash containing the server's response
  def self.send_request(*args)
    request = Request.new
    request.prepare(*args)
    request.execute
    request.response
  end

end
