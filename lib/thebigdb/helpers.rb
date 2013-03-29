module TheBigDB
  module Helpers

    # serialize_query_params({house: "bricks", animals: ["cat", "dog"], computers: {cool: true, drives: ["hard", "flash"]}})
    # => house=bricks&animals%5B%5D=cat&animals%5B%5D=dog&computers%5Bcool%5D=true&computers%5Bdrives%5D%5B%5D=hard&computers%5Bdrives%5D%5B%5D=flash
    # which will be read by the server as:
    # => house=bricks&animals[]=cat&animals[]=dog&computers[cool]=true&computers[drives][]=hard&computers[drives][]=flash
    def self.serialize_query_params(params, prefix = nil)
      ret = []
      params.each_pair do |key, value|
        param_key = prefix ? "#{prefix}[#{key}]" : key

        if value.is_a?(Hash)
          ret << self.serialize_query_params(value, param_key.to_s)
        elsif value.is_a?(Array)
          sub_hash = {}
          value.each_with_index do |value_item, i|
            sub_hash[i.to_s] = value_item
          end
          ret << self.serialize_query_params(sub_hash, param_key.to_s)
        else
          ret << URI.encode_www_form_component(param_key.to_s) + "=" + URI.encode_www_form_component(value.to_s)
        end
      end
      ret.join("&")
    end

    # flatten_params_keys({house: "bricks", animals: ["cat", "dog"], computers: {cool: true, drives: ["hard", "flash"]}})
    # => {"house" => "bricks", "animals[0]" => "cat", "animals[1]" => "dog", "computers[cool]" => "true", "computers[drives][0]" => "hard", "computers[drives][1]" => "flash"}
    def self.flatten_params_keys(params)
      serialized_params = self.serialize_query_params(params)
      new_params = {}
      serialized_params.split("&").each do |assign|
        key, value = assign.split("=")
        new_params[URI.decode(key)] = URI.decode(value)
      end
      new_params
    end

  end
end