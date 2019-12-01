# Ruby Gem Notes

## Install a gem

```bash
$ gem install nokogiri
```

## Fetch a gem's code and view it without installing

If you want to review a gem's code to decide if you want to use it, you can fetch and unpack it:

```bash
$ gem fetch nokogiri
$ gem unpack nokogiri-1.10.5.gem
```

This will create a folder with the gem's code in the current directory

## Build a basic gem

Create the following structure, for the example `hola` gem:

```bash
$ tree
.
├── hola.gemspec
└── lib
    └── hola.rb
```

The `lib/hola.rb` file is the file with your gem's code.  When you install a gem and require it, this is the file that gets loaded.

```ruby
class Hola
  def self.say_it
    puts "hello"
  end
end
```

The `hola.gemspec` file has information about the gem:

```ruby
Gem::Specification.new do |s|
  s.name        = "hola"
  s.version     = "0.0.0"
  s.date        = "2010-04-28"
  s.summary     = "Hola!"
  s.description = "A simple hello world gem"
  s.authors     = ["Nick Quaranto"]
  s.email       = "nick@quaran.to"
  s.files       = ["lib/hola.rb"]
  s.homepage    = "https://rubygems.org/gems/hola"
  s.license     = "MIT"
end
```

Then build and install the gem:

```bash
$ gem build hola.gemspec
```

This generates a gem binary package `hola-0.0.0.gem`.  Install this gem with:

```bash
$ gem install hola-0.0.0.gem
```

Then you can use the gem.  To try it out, start an IRB session, require and use it:

```bash
$ irb
irb(main):001:0> require "hola"
=> true
irb(main):002:0> Hola.hi
hello
=> nil
```
