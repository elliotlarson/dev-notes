# Ruby setup notes

## Installing Rbenv for Ruby version management

```bash
$ brew install rbenv ruby-build
$ brew rbenv init # this installs the shim in your shell profile
```

### Install a Ruby version with Rbenv

```bash
$ rbenv install 2.4.1
```

To use this version, add a `.ruby-version` file do the directory of your script or project.  The contents of this file will be the version you want.  So, something like `2.4.1`

### Setting a default global Ruby version

```bash
$ rbenv global 2.4.1
```

### Add gems for Ruby version

Add in Bundler

```bash
$ gem install bundler
```

Rehash `rbenv` so it recognizes the new bin executable for bundler

```bash
$ rbenv rehash
```

Then you can start using Bunldler:


```bash
$ bundle
```

## Basic utility script

Create a file `foo` and populate it with

```ruby
#!/usr/bin/env ruby
puts 'bar'
```

Make the file executable:

```bash
$ chmod +x foo
```

Execute the file with:

```bash
$ ./foo
#=> bar
```

## Basic ruby script called by Ruby directly

Create a file `foo.rb` and add this to it

```ruby
puts 'bar'
```

And you can call it with

```bash
$ ruby foo.rb
#=> bar
```

## A basic ruby script with gems

Make sure you have a `.ruby-version` file in the script's directory and bundler installed

Then initialize bundler for the directory

```bash
$ bundle init
```

This will stick a `Gemfile` in your directory, where you can add gems

Add in something like [pastel](https://github.com/piotrmurach/pastel)

```bash
$ echo "gem('pastel')" >> Gemfile
```

Install the new gem, which will add a `Gemfile.lock` in the same directory as your `Gemfile`

```bash
$ bundle
```

Then create a Ruby script `foo.rb` with the contents

```ruby
require 'rubygems'
require 'bundler/setup'
require 'pastel'

pastel = Pastel.new
puts pastel.blue('bar')
```
