# Rails Validation Notes

## Basics

You can define validations on an ActiveRecord model.  The most common approach is to use one of the predefined validation helpers.  For example:

```ruby
class Widgets < ActiveRecord::Base
  validates :name, presence: true
end
```

this validates that the name attribute on Widget is at least some non-blank string.

You can trigger validations manually with with `valid?` method:

```ruby
@widget = Widget.new
@widget.valid? #=> false
```

This will build up a set of error messages on the `@widget` instance.

You can view the error messages as a set of strings with:

```ruby
@widget.errors.messages
#=> {:name=>["can't be blank"]}

@widget.errors.full_messsages
#=> ["Name can't be blank"]

@widget.errors.details
#=> {:name=>[{:error=>:blank}]}

@widget.errors[:name]
#=> ["can't be blank"]

@widget.errors[:name].any?
#=> true

@widget.errors.details[:name]
#=> [{:error=>:blank}]
```

## Validation helpers

### `acceptance`

Verifies that a checkbox has been checked:

```ruby
validates :tos, acceptance: true
```

By default this checks that the value of the field is set to true.  If your checkbox has the true value of something else, like the string "yes", you can set this in the validator:

```ruby
validates :tos, acceptance: { accept: "yes" }
```

Or, an array of possible values:

```ruby
validates :tos, acceptance: { accept: %w[TRUE accepted] }
```

The acceptance validation can work without an actual attribute in the database.  If one does not exist, a virtual attribute is created by the validation.  In this case the validation only gets triggered if the value is false.

### `validates_associated`

If you need to ensure that associated records are valid before saving, you can use `validates_associated`.  The error message isn't great.

```ruby
class Widget < ActiveRecord::Base
  has_many :frobinators

  validates_associated :frobinators
end

class Frobinator < ActiveRecord::Base
  belongs_to :widget

  validates :name, presence: true
end

widget = Widget.new
widget.frobinators << Frobinator.new
widget.valid?
#=> false

widget.errors.full_messages
#=> ["Frobinators is invalid"]
```

This essentially calls `valid?` on each frobinator in the widget's collection.

### `confirmation`

You can confirm that a field is confirmed with another field:

```ruby
validates :email, confirmation: true
```

This creates a virtual attribute `email_confirmation` and ensures that email and it match.

### `exclusion` and `inclusion`

You can either validate that a value is in an array of values or NOT in an array of values:

```ruby
validates :subdomain, exclusion: { in: %w[www ca us] }
```

```ruby
validates :size, inclusion: {
  in: %w[small medium large],
  message: "%{value} is not one of the recognized sizes",
}
```

### `format`

You can verify that a value matches a regular expression with `format`:

```ruby
validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
```

You can also verify that a value does not match:

```ruby
validates :email, format: { without: /.*@badcomain.com\z/i }
```

Remember to use `\A` instead of `^` and `\z` instead of `$` for your regexp because they will deal with multiple lines.

You can not combine `with` and `without` in the same validation, but you can create two separate validations for the same field.

```ruby
validates :email, confirmation: true, format: {
  with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
}
validates :email, format: {
  without: /.*@baddomain.com\z/i,
  message: "with the 'baddomain.com' domain isn't allowed.",
}
```

## `length`

You can verify the length of a string, with `length`, using parameters:

* `minimum` = the string is at least a minimum number of characters
* `maximum` = the string is at most a maximum number of characters
* `in` = the string's length is within a range of values
* `is` = the string is exactly a specified length

```ruby
validates :username, length: { minimum: 3 }
validates :first_name, length: { maximum: 50 }
validates :password, length: { in: 8..30 }
validates :identifier_code, :length { is: 6 }
```

## Validations lab

When I want to poke around with validations, I use this little script:

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
  validates :name, presence: true
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

TODO: figure out how to integrate this into the validation lab
