# Nginx Notes

## Forcing SSL

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
location ^~ /www/admin/ {
    rewrite ^ https://domain.com$request_uri? permanent;
}
```
