# Ruby Rails Form Object

The form object is an object that backs a form in a Rails view.

* Validations are often contextual.  This provides a good container for validations that don't necessarily belong on a model in every situation
* Callbacks on models are evil (most of the time).  This provides a good container for things that should happen when creating or updating objects
* It provides a Facade for carrying out a number of actions that can be tested in isolation, keeping the controller and controller tests lean

Basic form object pattern:

```ruby
class MyFormObject
  include(ActiveModel::Model)

  def save
    return false unless valid?
    # some stuff goes here
    true
  end
end
```

You pass a hash of values to the constructor and `ActiveModel::Model`'s initializer assigns the values:

```ruby
class MyFormObject
  include(ActiveModel::Model)
  attr_accessor(:first_name, :last_name, :email)
end
fo = MyFormObject.new(first_name: 'Elliot', last_name: 'Larson')
puts(fo.first_name)
# => Elliot
```

You can add validations:

```ruby
class MyFormObject
  include(ActiveModel::Model)
  attr_accessor(:first_name, :last_name, :email)
  validates(:first_name, presense: true)
end
```

## Form Objects That Wrap Models

Usually a form object wraps one or more models in your system and handles creation or updating.

Here's a registration example that creates a user and related account:


```ruby
class RegistrationFormObject
  include(ActiveModel::Model)

  validates(:first_name, presense: true)
  validates(:last_name, presense: true)
  validates(:email, presense: true)

  # The name used in the form for the object key, which becomes
  # the parameter key you use in your controller
  def self.model_name
    ActiveModel::Name.new(self, nil, 'registration')
  end

  def save
    return false unless valid?
    # use bang methods because we should only be here if the user is valid
    user.save!
    RegistrationMailer.confirmation(user).deliver_later
    true
  end

  # We delegate to the model that's getting created. Notice that we delegate
  # the getters and the setters.
  delegate(
    :first_name,
    :'first_name=',
    :last_name,
    :'last_name=',
    :email,
    :'email=',
    to: :user
  )

  # Notice the single `&`.  This approach allows all validations to
  # be accumulated.  If you used `&&` it would stop at the first
  # invalid model
  def valid?
    user_valid? & self
  end

  private

  def account
    @_account ||= users.accounts.build(relationship: 'owner')
  end

  def user
    @_user ||= User.new
  end

  def user_valid?
    return true if user.valid?
    user.errors.messages.each { |k, ers| ers.each { |e| errors.add(k, e) } }
    false
  end
end
```

## Update Form Object

If you are updating a model, you may have access to this model in the controller and want to pass it in.

After Ruby 1.9, you can rely on the order of a hash, make sure you pass in the user as the first param.

Imagine you have a controller that looks like:

```ruby
def update
  @user = User.find(params[:id])
  @user_form_object = UserUpdatorFormObject.new(
    { user: @user }.merge(user_params)
  )
end

def user_params
  params.require(:user).permit(:first_name, :last_name, :email)
end
```

Then your form object will assign the user value first, and the d

```ruby
class UserUpdatorFormObject
  include(ActiveModel::Model)

  validates(:first_name, presense: true)
  validates(:last_name, presense: true)
  validates(:email, presense: true)

  def self.model_name
    ActiveModel::Name.new(self, nil, 'user')
  end

  def save
    return false unless valid?
    # some update stuff
    true
  end

  attr_accessor(:user)

  delegate(
    :first_name,
    :'first_name=',
    :last_name,
    :'last_name=',
    :email,
    :'email=',
    to: :user
  )

  def valid?
    user_valid? & self
  end

  private

  def user_valid?
    return true if user.valid?
    user.errors.messages.each { |k, ers| ers.each { |e| errors.add(k, e) } }
    false
  end
end
```

The other option is to pass the object in the constructor:

```ruby
class UserUpdatorFormObject
  include(ActiveModel::Model)

  attr_accessor(:user)

  def initialize(user, params)
    self.user = user
    super(params)
  end

  # ...
end
```