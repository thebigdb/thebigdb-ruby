require "net/https"
require "json"

%w(
  module_attribute_accessors
  shortcut
  request
).each do |file_name|
  require File.join(File.dirname(__FILE__), 'thebigdb', file_name)
end

module TheBigDB

  DEFAULT_VALUES = {
    "api_host" => "api.thebigdb.com",
    "api_port" => 80,
    "api_version" => "1",
    "use_ssl" => false,
    "verify_ssl_certificates" => false
  }

  mattr_accessor :api_host, :api_port, :api_version, :api_key
  mattr_accessor :use_ssl, :verify_ssl_certificates

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

  def self.reset_default_values
    DEFAULT_VALUES.each_pair do |key, value|
      send(key + "=", value)
    end
  end

  reset_default_values
end