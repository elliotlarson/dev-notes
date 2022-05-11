# Ruby Thor Notes

## Integration Testing The Output

We need to load the file and then capture the standard out.

This assumes the command uses something like `puts` to spit out a value.

In order to execute the task, we use the Thor `invoke` method.

```ruby
require('rails_helper')

Thor::Util.load_thorfile('lib/tasks/rxnorm_related_codes.thor')

def capture_stdout
  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdout = STDOUT
end

RSpec.describe('my_thor_command') do
  subject do
    capture_stdout do
      Thor.new.invoke('my_thor_command', [], verbose: true)
    end
  end

  let(:expected_output) do
    <<~HDOC
      => good stuff
    HDOC
  end

  it { is_expected.to eq(expected_output) }
end
```

## Calling Thor task from Rake task

Import thor tasks in `Rakefile`

```ruby
Dir["./lib/tasks/**/*.thor"].each { |f| load f }
```

Let's say we have a thor task:

```ruby
# /lib/tasks/foo.thor
class Foo < Thor
  desc "foo:bar <name>", "Fooness"
  method_options force: :boolean
  def bar(name)
    puts name
    if options[:force]
      puts "with force"
    end
  end
end
```

Then let's say we have a rake task we call the thor task from:

```ruby
# /lib/tasks/foo.rake
namespace :foo do
  task bar: :environment do
    foo = Foo.new
    foo.options = { force: true }
    foo.bar("baz")
  end
end
```

## Calling a Rake task from a Thor task

In your `Thorfile` you need to make sure to load the rake tasks:

```ruby
Rails.application.load_tasks
```

Let's say you have a rake task like this:

```ruby
# /lib/tasks/foo.rake
namespace :foo do
  task :bar, [:name, :force] => :environment do |t, args|
    puts args.name
    if args.force
      puts "with force"
    end
  end
end
```

Then you can call it from your thor task:

```ruby
# /lib/tasks/foo.thor
class Foo < Thor
  desc "foo:bar <name>", "Fooness"
  method_options force: :boolean
  def bar(name)
    Rake::Task["foo:bar"].invoke("baz", true)
  end
end
```

## Adding a thor task to Rails

Add a `Thorfile` to the root of your app, if it doesn't already exist:

```ruby
require File.expand_path('config/environment', __dir__)

Dir["./lib/tasks/**/*.thor"].each { |f| load f }
```

You can also add the binstub for the `thor` script:

```bash
$ bundler binstubs thor
```

Then you can add a basic task to `lib/tasks`.

```ruby
# lib/tasks/my_task.thor

require "thor"

class MyTask < Thor
  desc "do_something", "A task to do something"
  def do_something
    say "=> did it", :green
  end
end
```

Then you can run the task like so:

```bash
$ thor my_task:do_something
```
