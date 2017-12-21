# Ruby Access and API Notes

## Making a Get Request

Using RestClient:

```ruby
class Retriever
  URL = 'https://foofoofoo.example.com/api/stuffs'
  PARAMS = { params: { all: true } }.freeze

  def response_body
    @_response_body ||= JSON.parse(response.body)
  end

  def response
    @_response ||= RestClient.get(URL, PARAMS)
  end
end
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

First setup VCR to record the new episode:

```ruby
context('make an API call', vcr: { record: :new_episodes }) do
  # some testing code
end
```

Once the episode is recorded, remove the record config:

```ruby
context('make an API call', :vcr) do
  # some testing code
end
```
