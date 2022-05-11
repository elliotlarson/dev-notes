# Ruby FactoryBot Notes

## Attaching an image to a factory in a trait

```ruby
trait(:with_logo) do
  after(:build) do |organization|
    organization.logo.attach(
      io: File.open(Rails.root.join('spec/fixtures/lorem.png')),
      filename: 'lorem.png',
      content_type: 'image/png',
    )
  end
end
```
