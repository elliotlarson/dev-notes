# Ruby Misc Notes

## Working directly with HAML

```ruby
@hello = 'hi'
Haml::Engine.new('%h1 #{@hello} world').render(self)
```
