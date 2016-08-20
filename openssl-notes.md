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
