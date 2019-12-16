# Ruby Minitest Notes

To use Minitest you require `autorun`:

```ruby
require "minitest/autorun"
```

## A basic example of standard usage

```ruby
require "minitest/autorun"

class Foo
  def self.hi
    "yo"
  end
end

class TestFoo < Minitest::Test
  def test_should_return_yo
    assert_equal "yo", Foo.hi
  end
end
```

## A basic example of using the spec approach

```ruby
require "minitest/autorun"

class Foo
  def self.hi
    "yo"
  end
end

describe Foo do
  it "should return 'yo'" do
    assert_equal "yo", Foo.hi
  end
end
```

## Assertions

https://www.rubypigeon.com/posts/minitest-cheat-sheet/

TODO
