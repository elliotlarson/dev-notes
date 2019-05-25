# Ruby Code Spelunking Notes

Say you have a class:

```ruby
class Person
  def hi
    "hello"
  end
end
```

You can get a complete list of methods on an object by using the `methods` method:

```ruby
Person.new.methods
```

However, this is an exhaustive list of methods that are included from Ruby's `Object`.

To see just the methods for your object, subtract out Object's methods:

```ruby
Person.new.methods - Object.new.methods
```

To see the source location of a method:

```ruby
Person.new.method(:greet).source_location
#=> ["/Users/Elliot/Work/IronRidge/rails-backend/spike.rb", 2]
```

To see the implementation of a method:

```ruby
Person.new.method(:greet).source.display
# def greet
#   "hello"
# end
```

You can also get super methods:

```ruby
# ActiveRecord model
User.new.method(:save)
User.new.method(:save).super_method
```
