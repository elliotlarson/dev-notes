# Nginx Notes

## Forcing SSL

This amounts to redirecting traffic from HTTP to HTTPS.

To force SSL across the board:

```c
server {
       listen         80;
       server_name    my.domain.com;
       return         301 https://$server_name$request_uri;
}
```

To force SSL for a specific subdirectory:

```c
location ^~ /www/admin/ {
    rewrite ^ https://domain.com$request_uri? permanent;
}
```
