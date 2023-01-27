# Rails View Notes

## `class_names`

This is an alias for `token_list` and allows you to build up classes with conditionals:

```ruby
class_names(active: true, success: true)
# => "active success"
class_names(active: false, success: true)
# => "success"
```

## `local_assigns`

This is a way to pass local variables into a partial and check for their existence.

Let's say you did this:

```haml
= render "my_partial", foo: "bar"
```

You could access foo directly in your partial:

```haml
- if foo == "bar"
  You passed in "foo".
```

But if you tried to access a value that didn't exist:

```haml
- if baz.present?
  You passed in "baz".
```

This would error out because the value doesn't exist.

However if you used `local_assigns`, you could check for the existence like:

```haml
- local_assigns[:baz].present?
  You passed in "baz".
```
