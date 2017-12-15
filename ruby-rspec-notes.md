# Ruby Rspec Notes

## Workng with a tempfile

If you're testing with a file, it can be helpful to use the Ruby `Tempfile` utility, which will handle deleting the file on it's own.

```ruby
let(:tempfile) do
  Tempfile.new('my-file').tap do |f|
    f.write('foo foo foo')
    f.rewind
  end
end
```