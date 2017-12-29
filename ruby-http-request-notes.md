# Ruby HTTP Request Notes

## A few different approaches to making a request

### Using TCPSocket

http://ruby-doc.org/stdlib-2.4.2/libdoc/socket/rdoc/Socket.html

This is the lowest level Ruby approach.

```ruby
require 'socket'

host = 'www.ruby-lang.org/en/downloads/releases/'
port = 443

s = TCPSocket.open(host, port)
s.puts "GET / HTTP/1.1\r\n"
s.puts "\r\n"

while line = s.gets
  puts line.chop
end

s.close
```

### Using Net::HTTP

https://ruby-doc.org/stdlib-2.4.2/libdoc/net/http/rdoc/Net/HTTP.html

`Net::HTTP` is a part of the Ruby standard library, presenting a higher level API than `TCPSocket`.

```ruby
require('net/http')

uri = URI('https://www.ruby-lang.org/en/downloads/releases/')
res = Net::HTTP.get_response(uri)
puts(res.body)
```

Making an HTTPS request:

```ruby
require('net/https')

uri = URI.parse('https://www.ruby-lang.org')
request = Net::HTTP.new(uri.host, uri.port)
request.use_ssl = true
request.verify_mode = OpenSSL::SSL::VERIFY_NONE
response = request.get('/en/downloads/releases/')

puts(response.body)
```

### Using Open URI

https://ruby-doc.org/stdlib-2.4.2/libdoc/open-uri/rdoc/OpenURI.html

This is also a part of the Ruby standard library and is a wrapper for the `Net::HTTP` library, providing a simplified API for basic use cases:

```ruby
require('open-uri')

uri = URI.parse('https://www.ruby-lang.org/en/downloads/releases/')
puts(uri.read)
```

### Using Excon

https://github.com/excon/excon

Excon is an alternative to `Net::HTTP`:

```ruby
require('excon')

response = Excon.get('https://www.ruby-lang.org/en/downloads/releases/')
puts(response.body)
```

### Using Curb

https://github.com/taf2/curb

Curb is a Ruby wrapper for the curl command:

```ruby
require('curb')

http = Curl.get('https://www.ruby-lang.org/en/downloads/releases/')
puts(http.body_str)
```

### Faraday

https://github.com/lostisland/faraday

Faraday defaults to wrapping `Net::HTTP`.  You can also configure it wrap other solutions like Excon instead.

```ruby
require('faraday')

response = Faraday.get('https://www.ruby-lang.org/en/downloads/releases/')
puts(response.body)
```

### Rest client

https://github.com/rest-client/rest-client

RestClient is a wrapper on top of `Net::HTTP`

```ruby
require('rest_client')
url = 'https://www.ruby-lang.org/en/downloads/releases/'
params = {}
response = RestClient.get(url, { params: params })
```

#### A more fleshed out example

Using RestClient to grab weather data from Weather Underground:

```ruby
require('rest_client')

module Weather
  class Request
    STATE = 'CA'
    CITY = 'San_Francisco'
    BASE_URL = 'http://api.wunderground.com/api'
    API_KEY = 'abcdefghi'

    def self.call
      new.call
    end

    def call
      RestClient.get(url)
    end

    private

    def url
      "#{BASE_URL}/#{API_KEY}/conditions/q/#{STATE}/#{CITY}.json"
    end
  end
end
```

And then using this class:

```ruby
response = Weather::Request.call
response.code
response.body
```

## Parsing responses

Parsing JSON:

```ruby
JSON.parse(response.body)
```

Parsing XML (using ActiveSupport):

```ruby
Hash.from_xml(response.body)
```

## Testing with VCR

VCR setup `spec/support/vcr_setup.rb`:

```ruby
require('vcr')

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.ignore_localhost = true

  # Don't change this here! Instead, to record an initial cassette,
  # do this in your spec:
  #  describe SomeThing, vcr: { record: :new_episodes }
  # Then, once the cassette is recorded, change it to this:
  #  describe Something, :vcr
  config.default_cassette_options = { record: :none }

  config.filter_sensitive_data('AWS_ACCESS_KEY_ID') do
    ENV.fetch('AWS_ACCESS_KEY_ID', nil)
  end

  config.filter_sensitive_data('AWS_SECRET_ACCESS_KEY') do
    ENV.fetch('AWS_SECRET_ACCESS_KEY', nil)
  end
end
```

Notice the filtering of the AWS keys.  This is how you filter sensitive information out of cassettes.

First setup VCR to record the new episode:

```ruby
context('make an API call', vcr: { record: :new_episodes }) do
  subject { described_class.call }

  its(:code) { is_expected.to eq(200) }
end
```

Once the episode is recorded, remove the record config:

```ruby
context('make an API call', :vcr) do
  # testing code
end
```
