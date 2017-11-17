# SSL Notes

## Generating a self signed certificate

#### Generate the signing request

```bash
$ domain=onehou.se && openssl req -newkey rsa:2048 -nodes -keyout ${domain}.key -out ${domain}.csr
```

#### Self sign the request

```bash
$ openssl x509 -req -sha256 -days 365 -in ${domain}.csr -signkey ${domain}.key -out ${domain}.crt
```
