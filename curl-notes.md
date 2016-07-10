# cURL Notes

## Basic usage and get requests

#### Basic auth

```bash
$ curl -u myusername:mypassword http://somesite.com
```

#### Following redirects

```bash
$ curl -L www.sitethatredirects.com
```

#### Cookies

```bash
$ curl -b cookies.txt -c cookies.txt www.cookiesite.com
```

#### Show headers

Show headers and body:

```bash
$ curl -i http://onehouse.net
```

show only the headers:

```bash
$ curl -I http://onehouse.net
```

#### Download a file (force curl to use http 1.0)

```bash
$ curl -O http://ftp.drupal.org/files/projects/drupal-5.2.tar.gz
```

#### Specify a header

```bash
$ curl -H "Accept: text/xml" http://localhost:3000/books/sections/1
```

#### Specify a referer

```bash
$ curl -e http://google.com onehou.se
```

## Posting Data

#### Posting with form data

You can use a URL encoded string.

```bash
$ curl -d "birthyear=1905&press=%20OK%20" www.hotmail.com/when/junk.cgi
```

or, you can break out each item like so:

```bash
$ curl -d "book[title]=Test" -d "book[copyright]=1998" http://localhost:3000/books
```

#### Posting with an XML body

```bash
$ curl -v -H "Content-Type: application/xml; charset=utf8" -T update.xml
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<employee>
  <extension type="integer">7890</extension>
  <id type="integer">1</id>
  <name>Fairy Faucet</name>
</employee>
```

#### Posting with a JSON body

```bash
$ curl -X POST -H "Content-Type: application/json; charset=utf-8" -d @new.json http://localhost:3000/api/shorts
```

`./new.json`

```json
{"short": {"website_url": "http://www.onehouse.net"}}
```

## Deleting a resource

```bash
$ curl -X DELETE http://localhost:3000/employees/3.xml
```

## Outputting JSON results prettily

Using python, pipe call to `python -mjson.tool` which I have aliased to `pjson`:

```bash
$ curl http://api.openweathermap.org/data/2.5/forecast/daily\?id\=524901\&lang\=zh_cn | pjson
```
