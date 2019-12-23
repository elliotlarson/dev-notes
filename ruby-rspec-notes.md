# Ruby Rspec Notes

## Adding to a Rails site

Add the gem to the development/test groups:

```ruby
# Gemfile
group :development, :test do
  gem 'rspec-rails', '~> 4.0'
end
```

Install the gem:

```bash
$ bundle install
```

Run the generator:

```bash
$ rails generate rspec:install
```

## Workng with a tempfile

If you're testing with a file, it can be helpful to use the Ruby `Tempfile` utility, which will handle deleting the file on it's own.

```ruby
let(:tempfile) do
  Tempfile.new('my-file').tap do |f|
    f.write('foo foo foo')
    f.rewind
  end
end
```
