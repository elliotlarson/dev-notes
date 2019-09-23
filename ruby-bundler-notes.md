# Ruby Bundler Notes

## Installing gems in `vendor/bundle`

To generate a `.bundler` directory and set variables for your current app:

```bash
$ bundle config --local path vendor/bundle
```

Make sure to add `vendor/bundle` to your `.gitignore`.

## Install gems with parallel processes

You can install gems using multiple cores on your machine to speed things up:

```bash
$ bundle install -j4
```

## Using Bundler in a Script

Say you have a script `foo`.  When you execute this script, bundler will install any missing gems.

```ruby
#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "rubocop"
  gem "tty-prompt"
  gem "pry-byebug"   # Debugging with pry and byebug
  gem "pry-coolline" # Live syntax highlighting for pry
  gem "pry-doc"      # Documentation and source viewing in pry
  gem "pry-inline"   # Adds inline printing of values in the pry `whereami` code
end

tty = TTY::Prompt.new
color = Pastel.new

puts(color.cyan("Hello from `foo`"))
```
