require "./thebigdb/module_attribute_accessors"

module TheBigDB

  mattr_accessor :api_host, :api_version, :api_key
  mattr_accessor :use_ssl, :verify_ssl_certs

  self.api_host = "api.thebigdb.com"
  self.api_version = "1"

  self.use_ssl = false
  self.verify_ssl_certs = false

end