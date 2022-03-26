# Rails ActiveSupport

## `presence_in`

Returns the receiver if present, otherwise nil.

```ruby
params[:category].presence_in(%w[foo bar baz]) || "foo"
```

This is like `params.fetch(:category, "foo")` except it also makes sure the value exists in the list.
