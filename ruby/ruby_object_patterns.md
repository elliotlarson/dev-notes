# Ruby Object Patterns

## Singleton Pattern

## Observer Pattern

## Object Behaving Like a Hash

## Using OpenStruct to Create an Object Data Bag

## Configuration Block Pattern

This is used when you want to create an initializer file with configuration options in it (i.e. like a lot of third party gems allow you to do in a Rails initializer).

### configuration

```ruby
# initializer config pattern
MyGem.configure do |config|
  config.api_key = 'your_key_here'
end
```

### object implementation 

```ruby
module MyGem
  class Configuration
    attr_accessor :api_key
  end
    
  def self.configuration
    @configuration ||= Configuration.new
  end
	
  def self.configuration=(config)
    @configuration = config
  end
    
  def self.configure
    yield configuration
  end
end
```

### testing with rspec

```ruby
describe MyGem::Configuration do
  after { MyGem.configuration = nil }

  context 'adding in api_key' do
    let(:api_key) { 'my api key' }

    before do
      MyGem.configure { |config| config.api_key = api_key }
    end

    it 'has the api_key value' do
      expect(MyGem.configuration.api_key).to eq(api_key)
    end
  end
end
```

## Method Object

Pattern used for simple object that you usually initialize and make a single call on.  Using a class level method `call` you simplify the interface.  Arguments passed to `call` are passed through to the new method and an instance method `call` is called.  This allows you to automatically initialize the object and maintain state like you would with an object instance.

```ruby
class MyObj
  def self.call(*args)
    new(*args).call
  end
  
  def call
    # kick off my_object functionality
  end
end

```

## Simplifying Object Initialization With Struct

This helps to shorten the approach to initializing a simple object when you are passing in variables to a constructor that you want to be attar accessible. 

```ruby
class MyClass < Struct.new(:my_var)
end
```

This is the same as:

```ruby
class MyClass
  attr_accessor :my_var
  
  def initializer(my_var)
    self.my_var = my_var
  end
end
```

## Using Simple Delegator To Package Object Functionality

This is useful when you have a bit of similar functionality that all has to do with a particular object.  You pass the object into the initializer, and then by default all methods are delegated to the passed in object.

```ruby
class MyClass < SimpleDelegator
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def address
    "#{__getobj__.address}"
  end
end
```

Initialize the class with:

```ruby
user = User.find(42)
my_instance = MyClass.new(user)
```

## Include Class And Instance Methods Into Class

Used to easily mix class and instance methods into class.  This is useful when trying to add functionality of a particular type to an object.  For example, authentication functionality to a User model in Rails.

**Note:** The instance methods don't need to be namespaced into an InstanceMethods module.  They can live one level up in the base class, but it reads better because it makes the instance and class methods nested at the same level.

Include and extend are private methods on a class, so you need to use a bit of meta programming to use this, hence the use of send for both include and extend.

### Class You'd Like To Extend

```ruby
class User < ActiveRecord::Base
  include MyGroupedFunctionality
end
```

### Extending Functionality 

```ruby
class MyGroupedFunctionality
  def self.include(klass)
    klass.send :include, InstanceMethods
    klass.send :extend, ClassMethods
    
    klass do
      # execute some class level macros like:
      # validates presence of (active record)
    end
  end
  
  class ClassMethods
    def my_class_method
    end
  end
  
  class InstanceMethods
    def my_istance_method
    end
  end
end
```