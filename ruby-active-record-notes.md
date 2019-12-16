# Ruby ActiveRecord Notes

## Using in a basic script

```ruby
require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "sqlite3"
  gem "activerecord"
  gem "pry"
  gem "pry-coolline"
end

require "active_record"

ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:", # using in memory data store
)

ActiveRecord::Schema.define do
  create_table :widgets do |t|
    t.string :name
  end
end

class Widget < ActiveRecord::Base
end

binding.pry
1
```

## Changing the field name in a validation

Say you have a field with a name like `inv_num` on the `Order` model, and in validation errors you want to show "Invoice number".  You can change this name with the yaml locale language file `config/locales/en.yml`:

```yml
en:
  activerecord:
    attributes:
      order:
        inv_num: "Invoice number"
```
