# Rails View Notes

## `class_names`

This is an alias for `token_list` and allows you to build up classes with conditionals:

```ruby
class_names(active: true, success: true)
# => "active success"
class_names(active: false, success: true)
# => "success"
```
