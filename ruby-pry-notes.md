# Ruby Pry Notes

## Basic `.pryrc` setup

You can stick a `.pryrc` file in the root of the project, or you can stick it in your home directory as a default.

```ruby
Pry.config.editor = 'vim'

if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end
```

## Debugging Rails with Pry

See this video: https://www.youtube.com/watch?v=4hfMUP5iTq8

Let's say we have an error in our `users#index.html.erb` view.

Make sure you have the following gems in your Gemfile:

```ruby
gem 'gist' # allows copying of history
gem 'pry-byebug' # pry using byebug for debugging
gem 'pry-inline' # adds inline printing of values in the pry `whereami` code
gem 'pry-rails' # pry binding with Rails, making it the default rather than IRB
gem 'pry-rescue' # start pry binding at exception point
gem 'pry-stack_explorer' # allow exception stack navigation in pry
```

**Note:** At the time I'm writing this, you need the version of `pry-rescue` from GitHub.  There is a bug fix that is not in a released version of the gem that allows debugging of views in Rails (PR #106).

Start the Rails server with rescue:

```bash
$ rescue rails s
```

Navigate to error page http://localhost:3000/users.

If you have an error on the page, this will drop you into a pry runtime.

If your error is in a Rails view, you will hit pry line that looks like:

```ruby
=> 321: raise Template::Error.new(template)
```

You need to the source of the error with `cd-cause`, provided by `pry-rescue`.  You may need to do this twice.

```bash
[1] pry(#<ActionView::Template>)> cd-cause
```

This should eventually land you in your template on the line of the error:

```pry
=>  5: <%= @users.first.first_name %>

[1] pry(#<#<Class:0x00007fbc4ed6c010>>)>
```

This should allow you to plug away and find the solution:

```pry
[1] pry(#<#<Class:0x00007fbc4ed6c010>>)> @users
  User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."first_name" = ?  [["first_name", "foo"]]
=> []
[2] pry(#<#<Class:0x00007fbc4ed6c010>>)> @users.first
=> nil
[3] pry(#<#<Class:0x00007fbc4ed6c010>>)> @users.present? ? @users.first.first_name : 'no users'
=> "no users"
```

This solves our problem.  Now we can copy the last line to the clipboard:

```pry
[4] pry(#<#<Class:0x00007fbc4ed6c010>>)> clipit -i 3 # input line no 3
```

And, then we can edit the file:

```pry
[5] pry(#<#<Class:0x00007fbc4ed6c010>>)> edit -c # edit the current file
```

This opens the file in your editor at the line of the error where you can paste the copied line in to solve the problem.

Then, when you save your file and close it, you'll be back in pry, where you can ask pry-rescue to try again:

```pry
[6] pry(#<#<Class:0x00007fbc4ed6c010>>)> try-again
```

This re-reruns the request, hopefully successfully.

## Getting back some code entered in a temporary editor buffer

Say you've started a section of code that's going to span a few lines.  Instead of writing in pry, you enter `edit` to do it in your editor.

But in the edit section you save out of the temporary file

```ruby
Customer.pluck(:subdomain).each do |customer_name|
  ts(customer_name)
  provider_count = Provider.count
  program_count = Program.count
  puts("#{customer_name}, Providers: #{provider_count}, Programs: #{program_count}, product: #{provider_count * program_count}")
end
```

When you save this, the code will execute, but the history won't show it.

If you want to get this code back and modify it, you can use the `_in_` collection:

```text
> _in_.each_with_index { |ini, index| puts "#{index} #{ini}" }
```

This will print out the input collection.  All of the code will be on one of the input lines.  Use the array index ID to get the code back and edit it again:

```text
> edit --in 9
```

## Get the local variables defined in pry

```bash
$ pry
[1] pry(main)> foo = 'foo'
=> "foo"
[2] pry(main)> bar = 'bar'
=> "bar"
[3] pry(main)> ls
self.methods: inspect  to_s
locals: _  __  _dir_  _ex_  _file_  _in_  _out_  _pry_  bar  env  foo  old_prompt
[4] pry(main)> ls --locals
foo = "foo"
bar = "bar"
env = nil
old_prompt = nil
```

## Print out all instance variables for current object

If you've navigated into an object and you want to print out the instance variables, you can type `self`.

Here I've navigated into an instance of a `RestClient::Request` object.

```bash
[26] pry(#<RestClient::Request>)> self
=> #<RestClient::Request:0x00007f8535f81df0
 @block_response=nil,
 @cookies={},
 @headers={},
 @method=:get,
 @password=nil,
 @payload=nil,
 @raw_response=false,
 @ssl_opts={:verify_ssl=>1},
 @url="http://api.wunderground.com/api/a9766f280aacf3d6/conditions/q/CA/San_Francisco.json",
 @user=nil>
 ```
