# TheBigDB Ruby Wrapper

[![Build Status](https://secure.travis-ci.org/thebigdb/thebigdb-ruby.png)](http://travis-ci.org/thebigdb/thebigdb-ruby)

A simple ruby wrapper for making requests to the API of [TheBigDB.com](http://thebigdb.com). [Full API documentation](http://thebigdb.com/api).

## Install

    gem install thebigdb

## Simple usage

The following actions return a TheBigDB::StatementRequest object, on which you can add params using ``.with(hash_of_params)``.
The request will be executed once you call regular methods of Hash on it (``each_pair``, ``[key]``, etc.), or force it with ``load``.
The Hash returned represents the server's JSON response.

### Search \([api doc](http://thebigdb.com/api#statements-search)\)

    TheBigDB.search(subject: {match: "James"}, property: "job", answer: "President of the United States")
    TheBigDB.search(subject: "London", property: "population").with(period: {on: "2007-06-05"})
    TheBigDB.search("iPhone") # will fulltext search "iPhone" in all fields

### Create \([api doc](http://thebigdb.com/api#statements-create)\)

    TheBigDB.create(subject: "iPhone 5", property: "weight", answer: "112 grams")
    TheBigDB.create(subject: "Bill Clinton", property: "job", answer: "President of the United States").with(period: {from: "1993-01-20 12:00:00", to: "2001-01-20 12:00:00"})

### Show \([api doc](http://thebigdb.com/api#statements-show)\), Upvote \([api doc](http://thebigdb.com/api#statements-upvote)\) and Downvote \([api doc](http://thebigdb.com/api#statements-downvote)\)

    TheBigDB.show("id-of-the-sentence")
    TheBigDB.upvote("id-of-the-sentence")
    TheBigDB.downvote("id-of-the-sentence")

That's it!

## TheBigDB::Request object

If you want more details on what is sent and what is received, you can use the generic TheBigDB::Statement method. It returns a TheBigDB::Request object.
It has several readable attributes:
    
    request = TheBigDB::Statement(:search, {nodes: {subject: "iPhone", property: "weight"}})
    request.http              # Net::HTTP
    request.http_request      # subclass of Net::HTTPGenericRequest (Net::HTTP::Get or Net::HTTP::Post)
    request.http_response     # subclass of Net::HTTPResponse (e.g. Net::HTTPOK)
    request.data_sent         # Hash of the data sent, keys: "headers", "host", "port", "path", "method", "params"
    request.data_received     # Hash of the data received, keys: "headers", "content"
    request.response          # Hash, body of the http response converted from json

## Other Features

You can access other parts of the API in the same way as statements:
    
    TheBigDB::User(action, parameters)

    # Examples
    TheBigDB::User(:show, {login: "christophe"}).response["user"]["karma"]

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
