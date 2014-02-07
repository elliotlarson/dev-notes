# cURL Notes

#### posting with Data
	
	$ curl -d "birthyear=1905&press=%20OK%20" www.hotmail.com/when/junk.cgi

or

	$ curl -d "book[title]=Test" -d "book[copyright]=1998" http://localhost:3000/books

#### basic Auth

	$ curl -u myusername:mypassword http://somesite.com

#### following redirects

	$ curl -L www.sitethatredirects.com

#### cookies

	$ curl -b cookies.txt -c cookies.txt www.cookiesite.com

#### show headers

	$ curl -I onehou.se

#### download a file (force curl to use http 1.0)

	$ curl -O http://ftp.drupal.org/files/projects/drupal-5.2.tar.gz

#### specifying http action

	$ curl -X DELETE http://localhost:3000/books/1

#### specify a header

	$ curl -H "Accept: text/xml" http://localhost:3000/books/sections/1

#### specify a referer

	$ curl -e http://google.com onehou.se

#### post XML to Rails rest

	$ curl -v -H "Content-Type: application/xml; charset=utf8" -T update.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <employee>
        <extension type="integer">7890</extension>
        <id type="integer">1</id>
        <name>Fairy Faucet</name>
    </employee>

#### alternative post file method

	$ curl -v -H "Content-Type: application/json; charset=utf-8" -d @new.json http://localhost:3000/api/shorts.json

	# {"short": {"website_url": "http://www.onehouse.net"}}

#### delete restful Rails resource

	$ curl --request DELETE http://localhost:3000/employees/3.xml
