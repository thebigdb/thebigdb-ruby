# TheBigDB Ruby Wrapper

[![Build Status](https://secure.travis-ci.org/thebigdb/thebigdb-ruby.png)](http://travis-ci.org/thebigdb/thebigdb-ruby)

A simple ruby wrapper for making requests to the API of [TheBigDB.com][0].

## Install

    gem install thebigdb

## Usage

Make your requests using this structure:
    

    TheBigDB::Statement(action, parameters)


**[action]** => String of the action as described in the API (e.g. "search", "show", ...)  
**[parameters]** => Hash. Request parameters as described in the API. Tip: Arrays like ``["abc", "def"]`` will automatically be converted to ``{"0" => "abc", "1" => "def"}``


Examples:
    
    request = TheBigDB::Statement(:search,
      {
        nodes: [{search: ""}, "job", "President of the United States"],
        period: {from: "2000-01-01 00:00:00", to: "2002-01-01 00:00:00"}
      }
    )

    puts request.response

Will print something like:

    {
      "status" => "success",
      "statements" => [
        {"nodes" => ["Bill Clinton", "job", "President of the United States"], "id" => "8e6aec890c942b6f7854d2d7a9f0d002f5ddd0c0", "period"=>{"from" => "1993-01-20 00:00:00", "to" => "2001-01-20 00:00:00"}},
        {"nodes" => ["George W. Bush", "job", "President of the United States"], "id" => "3f27673816455054032bd46e65bbe4db8ccf9076", "period"=>{"from" => "2001-01-20 00:00:00", "to" => "2009-01-20 00:00:00"}}
      ]
    }

That's it!

## The TheBigDB::Request object

Every request you make will return a ``TheBigDB::Request`` object.
It has several readable attributes:
    
    request = TheBigDB::Statement(:search, {nodes: ["iPhone", "weight"]})
    request.http              # Net::HTTP
    request.http_request      # subclass of Net::HTTPGenericRequest (Net::HTTP::Get or Net::HTTP::Post)
    request.http_response     # subclass of Net::HTTPResponse (e.g. Net::HTTPOK)
    request.data_sent         # Hash of the data sent, keys: "headers", "host", "port", "path", "method", "params"
    request.data_received     # Hash of the data received, keys: "headers", "content"
    request.response          # Hash, body of the http response converted from json

## Other Features

You can access other parts of the API in the same way as statements:
    
    TheBigDB::User(action, parameters)
    TheBigDB::Toolbox::Unit(action, parameters)

    # Examples
    TheBigDB::User(:show, {login: "christophe"}).response["user"]["karma"]
    TheBigDB::Toolbox::Unit(:compare, {values: ["100 g", "1.2 kg"]}).response["result"]

You can modify the TheBigDB module with several configuration options:

    TheBigDB.api_key = "your-private-api-key"           # default: nil
    TheBigDB.use_ssl = true                             # default: false

    # If true, and a request response has {"status" => "error"}, it will raise a TheBigDB::Request::ApiStatusError exception with the API error code
    TheBigDB.raise_on_api_status_error = true           # default: false

    # Both of them take a Proc or a Lambda, the TheBigDB::Request instance is passed as argument
    TheBigDB.before_request_execution = ->(request){ logger.info(request.data_sent) }     # default: Proc.new{}
    TheBigDB.after_request_execution = ->(request){ logger.info(request.data_received) }  # default: Proc.new{}

    # You can also modify the configuration temporarily
    TheBigDB.with_configuration(use_ssl: true) do
      # your code here
    end


## Contributing

Don't hesitate to send a pull request !

## Testing
  
    rspec spec/

## License

This software is distributed under the MIT License. Copyright (c) 2013, Christophe Maximin <christophe@thebigdb.com>


[0]: http://thebigdb.com
