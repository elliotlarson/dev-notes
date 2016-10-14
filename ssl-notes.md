# SSL Notes

## Generating a self signed certificate

#### Generate the signing request

```bash
$ openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
$ openssl rsa -passin pass:x -in server.pass.key -out server.key
$ openssl req -new -key server.key -out server.csr
```

#### Self sign the request

```bash
$ openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt
```
