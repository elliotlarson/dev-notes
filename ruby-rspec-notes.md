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

## Testing in a single file

This can be useful if you are just trying out an idea and don't need more than a single file.

```ruby
require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "rspec"
end

require "rspec/autorun"

RSpec.describe "foo" do
  it "works" do
    expect(true).to be true
  end
end
```

## Hash including

```ruby
expect(response_json).to include(hash_including({
  employee: hash_including(jobs_count: 0)
}))
```

You could also use this:

```ruby
expect(subject).to match(a_hash_including(key: value))
```
