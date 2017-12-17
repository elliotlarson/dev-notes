# Ruby Pry Notes

## Debugging Rails with Pry

See this video: https://www.youtube.com/watch?v=4hfMUP5iTq8

Let's say we have an error in our `users#index.html.erb` view.

Make sure you have the following gems in your Gemfile:

```ruby
gem 'pry-rails' # pry binding with Rails, making it the default rather than IRB
gem 'pry-byebug' # pry using byebug for debugging
gem 'pry-rescue' # start pry binding at exception point
gem 'pry-stack_explorer' # allow exception stack navigation in pry
gem 'gist' # allows copying of history
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
