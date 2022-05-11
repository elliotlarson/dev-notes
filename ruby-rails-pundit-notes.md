# Pundit Notes

https://github.com/varvet/pundit

## Installation

Add the gem to your gemfile and then run the rake task:

```bash
$ rails g pundit:install
```

The task is optional, but will setup an application policy with useful defaults.

```ruby
class ApplicationController < ActionController::Base
  include Pundit::Authorization
end
```

## Generator

```bash
$ rails g pundit:policy post
```

## A Policy

By convention a policy has the name of a model in your system.

`app/policies/post_policy.rb`:

```ruby
class PostPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def update?
    user.admin? || !post.published?
  end
end
```

Generally you'll have an ApplicationPolicy that you can inherit from:

```ruby
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end
  #...
end
```

If you do this, you will inherit like so:

```ruby
class PostPolicy < ApplicationPolicy
  def update?
    user.admin? or not record.published?
  end
end
```

## Authorizing models in the controller layer

With a policy in place, you can use the `authorize` method in your controllers:

```ruby
def update
  @post = Post.find(params[:id])

  # This guy
  authorize @post

  if @post.update(post_params)
    redirect_to @post
  else
    render :edit
  end
end
```

Pundit does a couple of inferences here.  It infers from the model instance that there is a PostPolicy and it infers from the controller action that you want to check if the user is allowed to update this model.

You can manually pass a second argument to `authorize` to be explicit: `authorize @post, :update?`.

Behind the scenes, pundit does something like:

```ruby
unless PostPolicy.new(current_user, @post).update?
  raise Pundit::NotAuthorizedError, "not allowed to update? this #{@post.inspect}"
end
```

`authorize` will return the instance of the object, so you can do something like this:

```ruby
def show
  @user = authorize User.find(params[:id])
end
```

## Authorizing in the view layer

You can gain access to the policy object instance and call instance methods directly with `policy`:

```haml
- if policy(@post).update?
  = link_to "Edit post", edit_post_path(@post)
```

## Scopes

You can limit the records a user can see with a policy scope:

```ruby
class PostPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(published: true)
      end
    end

    private

    attr_reader :user, :scope
  end
end
```

This is nested inside of the PostPolicy and has the method `resolve`.

Then in your controller, you can use the `policy_scope` method to call through to the PostPolicy::Scope#resolve method:

```ruby
def index
  @posts = policy_scope(Post)
end

def show
  @post = policy_scope(Post).find(params[:id])
end
```

This is just a shortcut for:

```ruby
def index
  @publications = PublicationPolicy::Scope.new(current_user, Post).resolve
end
```

And you can use the `policy_scope` method in the views:

```haml
- policy_scope(@user.posts).each do |post|
  %p= link_to post.title, post_path(post)
```

## Ensuring authorization occurs

```ruby
class AuthorizationController < ApplicationController
  include Pundit::Authorization
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
end
```

## Rescuing from Pundit not authorized error

```ruby
class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
```
