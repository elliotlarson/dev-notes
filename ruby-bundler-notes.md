# Ruby Bundler Notes

## Deploying

When you deploy to a production server or to a CI environment, the user account you are deploying with may not have permissions to install system gems.  To deal with this, bundler has a special install flag:

```bash
$ bundle install --deployment
```

This installs gems in the `vendor/bundle` directory.  Even if there are system gems already on the machine that would satisfy a requirement, with this option in place, Bundler will not use them and instead opt to install a new gem in `vendor/bundle`.

Also, you can opt to cache gems by running:

```bash
$ bundler package
```

This will install gems in `vendor/cache`.  When you do this, Bundler will look in this directory for dependencies when you run `bundle install` before going out to rubygems.org to get them.  This will substantially speed up your dependency installs.

## Setting up Heroku

On heroku, you can set an environment variable so that bundler does not install specified groups during bundle install:

```bash
$ heroku config:set BUNDLE_WITHOUT="development:test"
```

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
