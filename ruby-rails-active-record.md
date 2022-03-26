# Active Record

## Has secure password

You can add password authentication to a user model with `has_secure_password`.

This expects the fields:

* `password_digest`

Add the method to a user model:

```ruby
class User < ApplicationRecord
  has_secure_password
end
```

This adds virtual attributes and methods to the model:

```bash
user = User.new(name: 'david', password: '', password_confirmation: 'nomatch')
user.save                                                  # => false, password required
user.password = 'mUc3m00RsqyRe'
user.save                                                  # => false, confirmation doesn't match
user.password_confirmation = 'mUc3m00RsqyRe'
user.save                                                  # => true
user.save                                                  # => true
user.authenticate('notright')                              # => false
user.authenticate('mUc3m00RsqyRe')                         # => user
User.find_by(name: 'david')&.authenticate('notright')      # => false
User.find_by(name: 'david')&.authenticate('mUc3m00RsqyRe') # => user
```

## Delegate Types

This is an alternative to Single Table Inheritance where there is a class hierarchy of delegates.  The parent class and table has access to shared fields and then the child classes and tables have fields specific to them.

Example:

```ruby
# Schema: entries[id, account_id, creator_id, created_at, updated_at, entryable_type, entryable_id]
class Entry < ApplicationRecord
  belongs_to :account
  belongs_to :creator
  delegated_type :entryable, types: %w[Message Comment]
end

# Schema: messages[id, subject]
class Message < ApplicationRecord
  has_one :entry, as: :entryable, touch: true
end

# Schema: comments[id, content]
class Comment < ApplicationRecord
  has_one :entry, as: :entryable, touch: true
end
```

You can create a Comment entry like so:

```ruby
comment = Entry.create! message: Comment.new(content: "Hello!"), creator: Current.user

# or with a utility method:
class Entry < ApplicationRecord
  def self.create_with_comment(content, creator: Current.user)
    create! message: Comment.new(content: content), creator: creator
  end
end
```

You can also take advantage of polymorphism:

```ruby
class Entry < ApplicationRecord
  delegated_type :entryable, types: %w[ Message Comment ]
  delegates :title, to: :entryable
end

class Message < ApplicationRecord
  def title
    subject
  end
end

class Comment < ApplicationRecord
  def title
    content.truncate(20)
  end
end
```

This allows you to query all entries:

```haml
- Entry.account.all.each do |entry|
  = render "entries/entryables/#{entry.entryable_name}", entry: entry
```

There are a number of utility methods that delegated types provides:

```ruby
@entry.entryable_class # => +Message+ or +Comment+
@entry.entryable_name  # => "message" or "comment"
@entry.messages        # => Entry.where(entryable_type: "Message")
@entry.message?        # => true when entryable_type == "Message"
@entry.message         # => returns the message record, when entryable_type == "Message", otherwise nil
@entry.message_id      # => returns entryable_id, when entryable_type == "Message", otherwise nil
Entry.comments         # => Entry.where(entryable_type: "Comment")
@entry.comment?        # => true when entryable_type == "Comment"
@entry.comment         # => returns the comment record, when entryable_type == "Comment", otherwise nil
@entry.comment_id      # => returns entryable_id, when entryable_type == "Comment", otherwise nil
```

## Active Record Lab

Use this to create an in memory setup so you can experiment with Active Record concepts outside the context of a Rails app:

```ruby
begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "rails", github: "rails/rails"
  gem "sqlite3"
end

require "active_record"
require "minitest/autorun"
require "logger"

# This connection will do for database-independent bug reports.
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :orders, force: true do |t|
  end
  create_table :products, force: true do |t|
    t.datetime :deleted_at
  end

  create_table :line_items, force: true do |t|
    t.references :order
    t.integer :purchasable_id
    t.string :purchasable_type
  end
end

class Order < ActiveRecord::Base
  has_many :line_items
  has_many :products, through: :line_items, source: :purchasable, source_type: 'Product'
end

class Product < ActiveRecord::Base
  has_many :line_items, as: :purchasable
end

class LineItem < ActiveRecord::Base
  belongs_to :purchasable, -> { where(deleted_at: false) }, polymorphic: true
end

class BugTest < Minitest::Test
  def test_association_stuff
    Product.create!
    assert_equal Order.joins(:products).where(products: {id: nil}).count, 0
  end
end
```
