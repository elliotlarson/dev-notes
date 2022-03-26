# Ruby Classes

## Making a constant private

Sometimes you want a constant on a class to be private, but it's nice to define them at the top of the class where things are public.

You can make a constant private with `private_constant`:

```ruby
class MyObj
  SECRET_INFO = "foofoo".freeze
  private_constant(:SECRET_INFO)
end
```
