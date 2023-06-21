# SSL Notes

## Command to view issued and expiry date for certificate

```bash
$ DOMAIN=google.com echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -dates
```

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
$ domain=acadia.org && openssl req -newkey rsa:2048 -nodes -keyout ${domain}.key -out ${domain}.csr
Generating a RSA private key
................+++++
.......+++++
writing new private key to 'acadia.org.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:US
Locality Name (eg, city) []:San Francisco
Organization Name (eg, company) [Internet Widgits Pty Ltd]:acadia
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:acadia.org
Email Address []:webmaster@acadia.org

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

For working with Namecheap Comodo:

`Upload the validation file to acadia.org/.well-known/pki-validation/`

Download the file from Namecheap, upload to server and then test
(e.g. http://acadia.org/.well-known/pki-validation/F188C64A33C5EEE04EDB3DA69F9C8265.txt)

When you get the signed crt from Namecheap:

> You need to have all the Certificates (your_domain.crt and your_domain.ca-bundle) combined in a single '.crt' file.

> The Certificate for your domain should come first in the file, followed by the chain of Certificates (CA Bundle).

> Enter the directory where you uploaded the certificate files. Run the following command to combine the files:

> $ cat your_domain.crt your_domain.ca-bundle >> your_domain_chain.crt

```bash
$ domain=acadia.org && cat ${domain}.crt ${domain}.ca-bundle >> ../${domain}.crt
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
