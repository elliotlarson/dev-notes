# Ruby Access and API Notes

## Making a Get Request

Using RestClient:

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
