# Openssl Notes

#### generating passwords with openssl:

```
$ openssl rand -hex 4
$ openssl rand -base64 6
$ repeat 25 openssl rand -hex 4
```

#### encrypting a file

```
$ openssl des3 -in foo.txt -out foo.txt.crypt
```

#### decrypting a file

```
$ openssl des3 -in foo.txt.crypt -out foo.txt -d
```


