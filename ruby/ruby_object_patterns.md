# Ruby Object Patterns

## Configuration Block Pattern

This is used when you want to create an initializer file with configuration options in it (i.e. like a lot of third party gems allow you to do in a Rails initializer).

```ruby
# initializer config pattern
MyGem.configure do |config|
  config.api_key = 'your_key_here'
end

# object implementation 
module MyGem
  class Configuration
    attr_accessor :api_key
  end
    
  def self.configuration
    @configuration ||= Configuration.new
  end
	
  def self.configuration=(config)
    @configuration = config
  end
    
  def self.configure
    yield configuration
  end
end

# testing with rspec
describe MyGem::Configuration do
  after { MyGem.configuration = nil }

  context 'adding in api_key' do
    let(:api_key) { 'my api key' }

    before do
      MyGem.configure { |config| config.api_key = api_key }
    end

    it 'has the api_key value' do
      expect(MyGem.configuration.api_key).to eq(api_key)
    end
  end
end
```

## Method Object

Pattern used for simple object that you usually initialize and make a single call on.  Using a class level method `call` you simplify the interface.  Arguments passed to `call` are passed through to the new method and an instance method `call` is called.  This allows you to automatically initialize the object and maintain state like you would with an object instance.

```ruby
class MyObj
  def self.call(*args)
    new(*args).call
  end
  
  def call
    # kick off my_object functionality
  end
end

```