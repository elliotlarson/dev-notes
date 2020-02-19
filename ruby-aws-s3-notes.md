# Ruby AWS S3 Notes

Using the aws-sdk-s3 gem: https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3.html

## Upload a file to a bucket 

Here I'm assuming we're using Rails and accessing the key and secret through the Rails config:

```ruby
client = Aws::S3::Client.new(
  access_key_id: Rails.configuration.aws[:aws_access_key_id],
  secret_access_key: Rails.configuration.aws[:aws_secret_key],
  region: "us-west-1",
)

client.put_object(
  bucket: "my-files", # base S3 bucket name
  key: "foo/bar/baz.txt", # filepath inside the base bucket
  body: "hello world", # the contents of the file
  acl: "private",
  content_disposition: "attachment; filename=\"baz.txt\"", # causes the file to download rather than open in the browser
)
```

## Check if an object exists 

```ruby
bucket = Aws::S3::Bucket.new(name: "my-files", client: client)
object = bucket.object("foo/bar/baz.txt")
object.exists?
```

## Get object information 

This returns basic information about the object

```ruby
object.data
object.data.content_length # size in bytes
object.data.last_modified 
```

## Get file contents 

You can use the `get` method on the object, which returns an `Aws::S3::Types::GetObjectOutput` object with the body on it.

```ruby
body_string_io = object.get.body # `StringIO` object 
body_string_io.string # the contents of the object
body_string_io.size # size of the string in bytes
```

## Download a file 

```ruby
object.download_file("file/path.txt")
```
