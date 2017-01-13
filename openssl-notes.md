# Openssl Notes

## Generating passwords with openssl:

```bash
$ openssl rand -hex 4
$ openssl rand -base64 6
$ repeat 25 openssl rand -hex 4
```

## Encrypting a file

```bash
$ openssl des3 -in foo.txt -out foo.txt.crypt
```

## Decrypting a file

```bash
$ openssl des3 -in foo.txt.crypt -out foo.txt -d
```

## Generating an SSL certificate

Generate a private key:

```bash
$ openssl genrsa -out myapp.com.key 2048
```

Create the certificate signing request:

```bash
$ openssl req -new -sha256 -key myapp.com.key -out myapp.com.csr
```

## Generating a self signed certificate

You can do this with a single command:

```bash
$ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout myapp.com.key -out myapp.com.crt
```
