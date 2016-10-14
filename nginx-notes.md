# Nginx Notes

## Forcing HTTP traffic to use HTTPS

This amounts to redirecting traffic from HTTP to HTTPS.

To force SSL across the board:

```nginx
server {
       listen         80;
       server_name    my.domain.com;
       return         301 https://$server_name$request_uri;
}
```

To force SSL for a specific subdirectory:

```nginx
# within the server block
location ^~ /www/admin/ {
    rewrite ^ https://domain.com$request_uri? permanent;
}
```

## Enabling SSL

Once you have a signed certificate, you can add them to the server and then reference them in your Nginx conf like so:

```nginx
server {
  listen 443 ssl;

  ssl    on;
  ssl_certificate    /etc/nginx/ssl/{{ app_domain_name }}.crt;
  ssl_certificate_key     /etc/nginx/ssl/{{ app_domain_name }}.key;
}
```