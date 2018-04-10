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

## List available cyphers

```bash
$ openssl list-cipher-commands
```

or

```bash
$ openssl ciphers -v
```

## Password encrypt a message

encrypt

```bash
$ echo 'foo' | openssl aes-256-cbc -a -salt
# enter aes-256-cbc encryption password:
# Verifying - enter aes-256-cbc encryption password:
# U2FsdGVkX1+xjBe4rymHvzSAHAOAcBqD5/Gy7LRfVJw=
```

decrypt

```bash
$ echo U2FsdGVkX1+xjBe4rymHvzSAHAOAcBqD5/Gy7LRfVJw= | openssl aes-256-cbc -a -d -salt
```

