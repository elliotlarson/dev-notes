# Ruby Misc Notes

## Working directly with HAML

```ruby
@hello = 'hi'
Haml::Engine.new('%h1 #{@hello} world').render(self)
```

## Showing gem documentation

You can use the gem command for this:

```bash
$ gem server
# Server started at http://[::]:8808
# Server started at http://0.0.0.0:8808
```

You can also use Yard for this.  Yard has slightly nicer formatting:

```bash
$ yard server --gems
```
