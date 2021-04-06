# ActionText notes

## Storage config

`config/storage.yml`

```yaml
test:
  service: Disk
  root: <%= Rails.root.join("tmp/storage") %>

local:
  service: Disk
  root: <%= Rails.root.join("storage") %>

amazon: &amazon
  service: S3
  access_key_id: <%= ENV["AWS_ACCESS_KEY_ID"] %>
  secret_access_key: <%= ENV["AWS_SECRET_KEY"] %>
  region: us-west-1

amazon_production:
  <<: *amazon
  bucket: attachments.ironridge.com

amazon_staging:
  <<: *amazon
  bucket: attachments.staging-ridge.com
```

## Working with S3

When working with S3, you need to configure Cors on the S3 bucket you're uploading to.  This is in the bucket's permissions section in the AWS console.  There's a place where you can provide a JSON policy:

Here's one I used for IronRidge

```json
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET",
            "PUT",
            "POST",
            "DELETE"
        ],
        "AllowedOrigins": [
            "https://base.ironridge.com"
        ],
        "ExposeHeaders": []
    }
]
```

## Testing with ngrok

Run ngrok command to start up a tunnel connected to your localhost:3000

```bash
$ ngrok http 3000
```

Make sure you update your development configuration in the `config/storage.yml` file to point to the appropriate S3 bucket.

You should see some output like:

```txt
Session Status                online
Account                       Elliot Larson (Plan: Basic)
Version                       2.3.38
Region                        United States (us)
Web Interface                 http://127.0.0.1:4040
Forwarding                    http://8c4c865f56b0.ngrok.io -> http://localhost:3000
Forwarding                    https://8c4c865f56b0.ngrok.io -> http://localhost:3000

Connections                   ttl     opn     rt1     rt5     p50     p90
                              0       0       0.00    0.00    0.00    0.00
```

Then run your rails server with the ngrok host:

```bash
NGROK_HOST=8c4c865f56b0.ngrok.io rails s
```

In my config file `config/environments/development.rb`, I have a line like this:

```ruby
config.hosts << ENV["NGROK_HOST"] if ENV["NGROK_HOST"].present?
```

Now you should be able to navigate to `https://8c4c865f56b0.ngrok.io` and test things out.
