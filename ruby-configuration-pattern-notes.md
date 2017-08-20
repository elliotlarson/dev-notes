# Ruby Configuration Pattern Notes

Inside the configuration class

```ruby
class Configuration
  attr_accessor :bar

  def initializer
    @bar = 'baz'
  end
end
```

Inside the base Foo module

```ruby
require('configuration')

module Foo
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @_configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
```