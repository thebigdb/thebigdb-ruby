%w(
  module_attribute_accessors
  shortcut
).each do |file_name|
  require File.join(File.dirname(__FILE__), 'thebigdb', file_name)
end

module TheBigDB

  mattr_accessor :api_host, :api_version, :api_key
  mattr_accessor :use_ssl, :verify_ssl_certs

  self.api_host = "api.thebigdb.com"
  self.api_version = "1"

  self.use_ssl = false
  self.verify_ssl_certs = false

end