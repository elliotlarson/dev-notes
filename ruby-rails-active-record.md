# Active Record

## Figure out what the database pool size is

```ruby
ActiveRecord::Base.connection_pool.size
```

## Aggregate counting

Getting users who have created 10 or more projects in the past 2 years:

```ruby
Project.where.not(user_id: nil)
       .where("created_at > ?", 2.years.ago)
       .select(:user_id, "COUNT(*) AS count")
       .group(:user_id)
       .having("COUNT(*) > 9")
       .to_sql

# => SELECT "projects"."user_id", COUNT(user_id) as count FROM "projects" WHERE "projects"."user_id" IS NOT NULL AND (created_at > '2020-12-02 20:43:32.412328') GROUP BY "projects"."user_id" HAVING (count > 9)
```

## Aggregate count & sort through association

Getting a list of companies ordered by count of memberships (companies have many memberships)

```ruby
Company.left_joins(:memberships)
       .select("companies.*, COUNT(company_memberships.id) as count")
       .group("companies.id")
       .order("count desc")
       .limit(100)
       .map { |p| [p.id, p.name, p.count] }
```

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

## Using `merge` to join scopes

https://gorails.com/blog/activerecord-merge

```ruby
class Author < ActiveRecord::Base
  has_many :books
end

class Book < ActiveRecord::Base
  belongs_to :author

  scope :available, ->{ where(available: true) }
end
```

Instead of this:

```ruby
Author.joins(:books).where("books.available = ?", true)
```

You can use merge like this:

```ruby
Author.joins(:books).merge(Book.available)
```

Merge will replace previous pieces of a scope chain that reference the same field key:

```ruby
User.where(id: [1, 2]).merge(User.where(id: [2, 3])).to_sql
#=> "SELECT \"users\".* FROM \"users\" WHERE \"users\".\"id\" IN (2, 3)">
```

## Using `and` to join scopes

Merge replaces previous keys in the scope chain whereas `and` composes the intersection:

```ruby
User.where(id: [1, 2]).and(User.where(id: [2, 3])).to_sql
#=> "SELECT \"users\".* FROM \"users\" WHERE \"users\".\"id\" IN (1, 2) AND \"users\".\"id\" IN (2, 3)"
```
