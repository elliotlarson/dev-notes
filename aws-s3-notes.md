# AWS S3 Notes

## Setting up https with a custom domain

S3 doesn't support https natively.  Instead you need to create a CloudFront distribution with an SSL certificate for the desired domain, and then point a CNAME record (A record for Route 53) to the domain.

1. Setup an S3 bucket with the name of your domain
  * Configure it for static site hosting
  * Open it up to the public
  * Add policy that lets people access it via Get
    ```json
    {
        "Version": "2008-10-17",
        "Id": "Policy1423098190857",
        "Statement": [
            {
                "Sid": "Stmt1423098188124",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "*"
                },
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::files.ironridge.com/*"
            }
        ]
    }
    ```
2. Create a certificate for the domain (If you are creating a cert on AWS, you need to do this in the N. Virginia region)
3. Create a CloudFront distribution
  * The domain is the domain in the S3 static site hosting section (don't select the bucket from the dropdown list, even though this seems correct)
  * Redirect http to https
  * Link to the certificate
  * Add in your domain as an alternate domain name
4. Then create a DNS entry pointing your domain to the distribution URL
  * If you're using Route 53, this is an A record with an alias (you select the distribution through a series of dynamic dependent select lists)
  * If you're using 3rd party DNS, this is a CNAME record
