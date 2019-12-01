# Ruby Build a Gem Notes

## Generate basic structure

The easiest way to do this is to use bundler

### Get information about the command

```bash
$ bundle gem -h
```

### Generate basic gem with rspec

```bash
$ bundle gem foo --test=rspec
```

### Generate basic gem with an executable

```bash
$ bundle gem foo --test=rspec -b
```

## Setting up a console

```bash
$ irb -I './lib' -r foo
```

* `-I` tells irb to add the `./lib` directory to the loadpath
* `-r` tells irb to require the "foo" library

You can add this to a rake task.  In your `Rakefile`

```ruby
task(:console) do
  exec("irb -I './lib' -r foo")
end
```

### Adding pry

Lets say we want to add pry.

Add this line to the `.gemspec` file for your gem and run the `bundle` command

```ruby
spec.add_development_dependency 'pry'
```

Then, you'll need to require this to use it, however this gem will only be present in the development environment causing a `LoadError`.  Add the requirement statement to one of your classes like this:

```ruby
begin
  require('pry')
rescue LoadError
end
```

You can also update the `console` task in your `Rakefile`

```ruby
task(:console) do
  exec("pry -I './lib' -r foo")
end
```

## Thor and executables

In order for thor subcommands to load appropriately, I needed to set my executable up with the lib directory of the gem manually added to the loadpath:

```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[.. lib]))

require 'rubygems'
require 'my_gem'

MyGem::CLI.start(ARGV)
```
