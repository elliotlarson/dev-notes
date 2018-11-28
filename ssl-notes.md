# SSL Notes

## Comodo SSL from NameCheap

Generate a CSR (signing request), like shown below.

Choose the HTTP verification method.  They will give you a file with a name like `E58996C5861F2EF2074DEED44AC173D8.txt` that you are meant to upload to your webserver such that it it available at `http://<domain>/.well-known/pki-validation/E58996C5861F2EF2074DEED44AC173D8.txt`.

When they send you the CRT, combine it with the CA bundle file.  For example:

```bash
$ cat admin_wpbinc_com.crt admin_wpbinc_com.ca-bundle > ssl.admin.wpbinc.com/admin.wpbinc.com.crt
```

## Generating a certificate

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
