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

It's worth mentioning that when you call `@widget.valid?`, it clears out the existing errors on the object and builds a fresh list.  So if you've manually added errors, these will get removed:

```ruby
@widget.valid?
# => false
@widget.errors.base << "Another error"
@widget.errors.full_messages
# => ["Name can't be blank", "Another error"]
@widget.valid?
@widget.errors.full_messages
# => ["Name can't be blank"]
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

### `length`

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

### `numericality`

Validates that the value is a number.  You can verify the characteristics of the number value:

* `greater_than` = ensure the value is greater than a number
* `greater_than_or_equal_to` = ensure the value is greater than or equal to a number
* `equal_to` = ensure the value is equal to
* `less_than` = ensure the value is less than a number
* `less_than_or_equal_to` = ensure a value is less than or equal to a number
* `other_than` = ensure a value is anything other than a supplied value
* `odd` = ensure the value is odd
* `even` = ensure the value is even
* `only_integer` = ensures the value is not a float/decimal

```ruby
validates :price, numericality: { greater_than: 0 }
validates :price, numericality: { greater_than_equal_to: 1 }
validates :price, numericality: { less_than: 10000 }
validates :price, numericality: { less_than_equal_to: 99999 }
validates :identifier, numericality: { equal_to: 1 }
validates :identifier, numericality: { other_than: 42 }
validates :identifier, numericality: { odd: true }
validates :identifier, numericality: { even: true }
validates :identifier, numericality: { only_integer: true }
```

You can also add the `allow_nil: true` flag to allow an empty value.

### `presence`

This ensures a value is not blank.  It uses the `blank?` method.

```ruby
validates :username, present: true
```

### `absence`

Ensures the value is not set:

```ruby
validates :name, :login, :email, absence: true
```

### `uniqueness`

Ensures a value is unique.

```ruby
validates :email, uniqueness: true
```

You can scope this to another field:

```ruby
validates :name, uniqueness: { scope: :year, message: "can only happen once a year" }
```

You can also scope to multiple columns:

```ruby
validates :name, uniqueness: { scope: [:region, :group] }
```

There also may be cases where you want to ensure a string is unique regardless of case:

```ruby
validates :email, uniqueness: { case_sensitive: false }
```

### `validates_with`

You can use a custom validator object to package validation logic:

```ruby
class GoodnessValidator < ActiveModel::Validator
  def validate(record)
    return unless record.first_name == "Evil"
    record.errors[:base] << "This person is evil"
  end
end

class Person < ActiveRecord::Base
  validates_with GoodnessValidator
end
```

These validators take `:if`, `:unless`, and `:on` options.

*Note*: The validator class is initialized once per application run so refrain from using instance variables in the constructor.  If you need this, use the `validate` method and pass the object to a plain old Ruby object.

### `validate`

If you have some complicated validation logic you can move it out into a method and call this with `validate`:

```ruby
class Person < ActiveRecord::Base
  validate :ensure_salary_in_appropriate_range

  private

  def ensure_salary_in_appropriate_range
    salary_range = SalaryRangeCalculator.call(self)
    return if salary.between?(salary_range)
    errors.add(
      :salary,
      "the salary %{value} is not in the range " \
      "#{salary_range.to_a.first}-#{salary_range.to_a.last}",
    )
  end
end
```

You can also pass a block to the validator instead, where self becomes the object being validated:

```ruby
class Person < ActiveRecord::Base
  validate do
    salary_range = SalaryRangeCalculator.call(self)
    return if salary.between?(salary_range)
    errors.add(
      :salary,
      "the salary %{value} is not in the range " \
      "#{salary_range.to_a.first}-#{salary_range.to_a.last}",
    )
  end
end
```

Or, you can use a block with an argument for the currently being validated object:

```ruby
class Person < ActiveRecord::Base
  validate do |person|
    person.ensure_salary_in_appropriate_range
  end

  private

  def ensure_salary_in_appropriate_range
    salary_range = SalaryRangeCalculator.call(self)
    return if salary.between?(salary_range)
    errors.add(
      :salary,
      "the salary %{value} is not in the range " \
      "#{salary_range.to_a.first}-#{salary_range.to_a.last}",
    )
  end
end
```

### `validate_each`

You can write a custom validator that adds a validation helper:

```ruby
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    message = options[:message] || "is not an email"
    record.errors.add(attribute, message)
  end
end

class Person < ActiveRecord::Base
  validates :email, email: true
end
```

Notice how the email validator is made available off of the `validates` method.

## Get a list of validators in use

You can use the class method `validators` to get all validators used for a class:

```ruby
User.validators
# => [#<ActiveRecord::Validations::PresenceValidator:0x00007fbf74661ad0 @attributes=[:email], @options={:if=>:email_required?}>,
#  #<ActiveRecord::Validations::UniquenessValidator:0x00007fbf7466ad10
#   @attributes=[:email],
#   @klass=User (call 'User.connection' to establish a connection),
#   @options={:allow_blank=>true, :case_sensitive=>true, :if=>:will_save_change_to_email?}>,
#  #<ActiveModel::Validations::FormatValidator:0x00007fbf74690ad8 @attributes=[:email], @options={:with=>/\A[^@\s]+@[^@\s]+\z/, :allow_blank=>true, :if=>:will_save_change_to_email?}>,
#  #<ActiveRecord::Validations::PresenceValidator:0x00007fbf746982d8 @attributes=[:password], @options={:if=>:password_required?}>,
#  #<ActiveModel::Validations::ConfirmationValidator:0x00007fbf746a2ad0 @attributes=[:password], @options={:case_sensitive=>true, :if=>:password_required?}>,
#  #<ActiveRecord::Validations::LengthValidator:0x00007fbf746a0b90 @attributes=[:password], @options={:allow_blank=>true, :minimum=>6, :maximum=>128}>,
#  #<ActiveRecord::Validations::PresenceValidator:0x00007fbf73d3c7e8 @attributes=[:person], @options={:message=>:required}>]
```

You can also use the `validators_on` method to get the validators used for a specific field:

```ruby
User.validators_on(:email)
# => [#<ActiveRecord::Validations::PresenceValidator:0x00007fbf74661ad0 @attributes=[:email], @options={:if=>:email_required?}>,
#  #<ActiveRecord::Validations::UniquenessValidator:0x00007fbf7466ad10
#   @attributes=[:email],
#   @klass=User (call 'User.connection' to establish a connection),
#   @options={:allow_blank=>true, :case_sensitive=>true, :if=>:will_save_change_to_email?}>,
#  #<ActiveModel::Validations::FormatValidator:0x00007fbf74690ad8 @attributes=[:email], @options={:with=>/\A[^@\s]+@[^@\s]+\z/, :allow_blank=>true, :if=>:will_save_change_to_email?}>]
```

## You can add ActiveModel validations to a plain old ruby object

```ruby
class Dude
  include ActiveModel::Validations

  attr_accessor :name

  validates :name, presence: true
end
```

## Validates options

### `if`

You can use the `if` option to create conditional validations.

You can pass a symbol of a method name for a method that returns a boolean value of true when you want to validate something:

```ruby
class Person < ActiveRecord::Base
  validates :dudeness_score, numericality: { greater_than: 42 }, if: :dude?

  def dude?
    kind_of_person == "dude"
  end
end
```

You can also use a lambda:

```ruby
class Person < ActiveRecord::Base
  validates :dudeness_score,
            numericality: { greater_than: 42 },
            if: ->(person) { person.kind_of_person == "dude" }
end
```

You can also use `unless`:

```ruby
class Person < ActiveRecord::Base
  validates :very_undudeness_score,
            numericality: { greater_than: 42 },
            unless: ->(person) { person.kind_of_person == "dude" }
end
```

### `message`

This is an option for individual validations.

If you don't want to use the default message for a validation, you can pass in a unique message:

```ruby
class Person < ActiveRecord::Base
  validates :name, presence: { message: "is super super required" }
end
```

The message can also include dynamically replaced values:

```ruby
class Person < ActiveRecord::Base
  validates :email, format: {
    with: /.*@baddomain.com/i,
    message: "with %{value} is not allowed",
  }
end
```

You can also use `%{attribute}` and `%{model}`.

If you need to get a little more dynamic with the message, you can pass in a block:

```ruby
class Person < ActiveRecord::Base
  validates :username,
    uniqueness: {
      # object = person object being validated
      # data = { model: "Person", attribute: "Username", value: <username> }
      message: ->(object, data) do
        "Hey #{object.name}!, #{data[:value]} is taken already!"
      end
    }
end
```

Notice, though, that this message when outputted with `@person.errors.full_messages`: "Username Hey dude!, foo is taken already!"

### `on`

Validations are often contextual.  You can use the standard action contexts of `:create` and `:update`.

```ruby
class Person < ActiveRecord::Base
  validates :age, numericality: true, on: :create
end
```

But you can also define custom contexts.  If you do this, you have to use `valid?` and `save` with the context parameter passed in.

```ruby
class Person < ActiveRecord::Base
  validates :username, length: { greater_than: 6 }, on: :registration
end

person = Person.new
person.valid?(:registration)
person.save(context: :registration)
```

## Callbacks

You can add in callbacks to perform actions before and after validation occurs.

### `before_validation`

```ruby
before_validation :remove_whitespace

private

def remove_white_space
  username.strip!
end
```

### `after_validation`

```ruby
after_validation :set_status

private

def set_status
  self.status = errors.empty?
end
```

### Adding to non-ActiveRecord class

The callbacks come with ActiveRecord objects, but if you are adding validations to a plain old Ruby object, the callbacks need to be added separately:

```ruby
class Person
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  attr_accessor :username

  validates :username, length: { in: 6..20 }

  before_validation :remove_whitespace

  private

  def remove_white_space
    username.strip!
  end
end
```

## Strict validations

You can configure a validation to raise an error in the case of invalidity:

```ruby
class Person
  include ActiveModel::Validations

  attr_accessor :name

  validates_presence_of :name, strict: true
end

person = Person.new
person.name = nil
person.valid?
# => ActiveModel::StrictValidationFailed: Name can't be blank
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
