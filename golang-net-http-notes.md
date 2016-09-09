# Golang `net/http` Notes

## Making requests

#### Getting a webpage

You can get a web page with the `Get` method.  It accepts a string URL, and returns both a [Response type](https://golang.org/pkg/net/http/#Response) and a potential error.  

The `Response` type has some useful pieces of data:

* **Status** string // "200 OK"
* **StatusCode** int // 200
* **Header** type Header map[string][]string
* **Body** type io.ReadClose interface

```go
import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func main() {
	resp, err := http.Get("https://news.ycombinator.com")
	if err != nil {
		fmt.Printf("Error retrieving page: %s\n", err)
	}
	defer resp.Body.Close()

	fmt.Printf("\nResponse Values:\n")
	fmt.Println("================")
	fmt.Printf("Status: %s\n", resp.Status)                // string
	fmt.Printf("Status Code: %d\n", resp.StatusCode)       // int
	fmt.Printf("Content Length: %d\n", resp.ContentLength) // int64

	// resp.Header = type Header map[string][]string
	fmt.Printf("\nHeaders:\n")
	fmt.Println("========")
	for headerName, headerValues := range resp.Header {
		fmt.Printf("%s: %s\n", headerName, headerValues)
	}

	fmt.Printf("\nBody:\n")
	fmt.Println("========")
	body, err := ioutil.ReadAll(resp.Body)
	fmt.Printf("%s\n", body)
}
```

#### Posting to a resource endpoint

You can also make a request that behaves like posting a form:

```go
import (
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
)

func main() {
	query := url.Values{}
	query.Set("user[first_name]", "Jeffrey")
	query.Set("user[last_name]", "Lebowski")
	fmt.Printf("%s\n", query.Encode())

	resp, err := http.PostForm("http://localhost:3000/users", query)
	if err != nil {
		fmt.Println(err)
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	fmt.Printf("%s\n", body)
}
```

Or, you can use the `Post` method to post JSON:

```go
import (
	"fmt"
	"net/http"
	"os"
	"strings"
)

func main() {
	bodyJson := `{"user": {"first_name": "Jeffrey", "last_name": "Lebowski"}}`
	bodyJsonReader := strings.NewReader(bodyJson)

	resp, err := http.Post("http://localhost:3000/users.json",
		"application/json", bodyJsonReader)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	defer resp.Body.Close()

	// some processing stuff
}
```

## Creating a webserver: defining your own `Server` struct

#### Creating a server with a single handler

This is an approach where you don't use a multiplexer.  In this example, we'll use our own instance of the `Server` struct and apply a single handler to it.

```go
type MySingleHandler struct{}

func (msh *MySingleHandler) ServeHTTP(writer http.ResponseWriter, request *http.Request) {
  fmt.Fprintf(writer, "Hello, World!")
}

func main() {
  mySingleHandler := &MySingleHandler{}
  server := http.Server{
    Addr: '127.0.0.1:8088',
    Handler: mySingleHandler,
  }
  server.ListenAndServe()
}
```

This version of `ListenAndServe` is a method defined on the `http` package's struct `Server` and takes no arguments.  All parameters are defined as values on the struct.

With this in place, any/all URLs are routed to this single handler.

#### Expand this to multiple handlers

If you don't supply the `Handler` value to the `Server` struct, the `DefaultServerMux` mulitplexer gets used.  Then as you call `http.Handle` functions, these handlers get added to the `DefaultServerMux`.

```go
type HelloHandler struct{}

func (h *HelloHandler) ServeHTTP(writer http.ResponseWriter, request *http.Request) {
  fmt.Fprintf(writer, "Hello!")
}

type WorldHandler struct{}

func (h *WorldHandler) ServerHTTP(writer http.ResponseWriter, request *http.Request) {
  fmt.Fprintf(writer, "World!")
}

func main() {
  worldHandler := &WorldHandler{}
  helloHandler := &HelloHandler{}

  http.Handle("/world", worldHandler)
  http.Handle("/hello", helloHandler)

  server := http.Server{
    Addr: "127.0.0.1:8088",
  }

  server.ListenAndServe()
}
```

#### Defining your own multiplexer

Instead of using the `DefaultServerMux`, you can define your own custom server multiplexer:

```go
type HelloHandler struct{}

func (h *HelloHandler) ServeHTTP(writer http.ResponseWriter, request *http.Request) {
	fmt.Fprintf(writer, "Hello, World!")
}

func main() {
	mux := http.NewServeMux()

	helloHandler := &HelloHandler{}
	mux.Handle("/hello", helloHandler)

	server := http.Server{
		Addr:    "127.0.0.1:8088",
		Handler: mux,
	}

	server.ListenAndServe()
}
```

`NewServeMux` creates a new instance of the `ServeMux` struct.  Here is the code for this:

```go
type ServeMux struct {
	mu    sync.RWMutex
	m     map[string]muxEntry
	hosts bool // whether any patterns contain hostnames
}
```

`ServeMux` also satisfies the `Handler` interface because it has a `ServeHTTP` function, which finds the closest matching requested pattern and calls the related handler.

## Working with `http.HandleFunc`

When you use `http.HandleFunc` instead of `http.Handle`, it takes in a function that has the same signature of `ServeHTTP`.  Under the hood this function adapts the function into a `Handler` for use with the `DefaultServerMux`.

```go
func rootHandler(w http.ResponseWriter, req *http.Request) {
  fmt.Fprintf(w, "Hello, World!")
}

func main() {
  http.HandleFunc("/", rootHandler)
  http.ListenAndServe(":8888", nil)
}
```

Here is the `ListenAndServe` function signature:

```go
func ListenAndServe(addr string, handler Handler) error
```

And, `handler` is an interface that has a `ServeHTTP` method on it.  `HandleFunc` converts the handler function into a type that has this method, using the `HandlerFunc` function under the hood.

`HandleFunc` is a convenience abstraction for:

```go
http.Handle("/", HandlerFunc(rootHandler))
```

Since `ListenAndServe` accepts a handler as a second argument, you can rewrite this as:

```go
func rootHandler(w http.ResponseWriter, req *http.Request) {
  fmt.Fprintf(w, "Hello, World!")
}

func main() {
  http.ListenAndServe(":8888", http.HandlerFunc(rootHandler))
}
```

## Using `HandlerFunc` to add adpater functionality to handler functions

`HandlerFunc` takes in a handler function and returns a handler function.  This approach allows you to add adapter functionality to a handler function, like logging or authentication, without altering the function.  You then "chain" the function calls, like so:

```go
func hello(writer http.ResponseWriter, request *http.Request) {
  fmt.Fprintf(writer, "Hello, World!")
}

func log(hf http.HandlerFunc) http.HandlerFunc {
  return func(writer http.ResponseWriter, request *http.Request) {
    fmt.Println(time.Now(), request.RequestURI)
    hf(writer, request)
  }
}

func main() {
  http.HandleFunc("/", log(helloHandler))
  http.ListenAndServe(":8088", nil)
}
```

Our log function takes in a handler function and then returns an anonymous function with the same signature.  When called, the anonymous function does some logging and then calls the original handler function.

#### Diving into the sourcecode

Here is the `http` source code for `HandleFunc`:

```go
func HandleFunc(pattern string, handler func(ResponseWriter, *Request)) {
	DefaultServeMux.HandleFunc(pattern, handler)
}
```

This just calls through to the `mux.HandlerFunc` method:

```go
func (mux *ServeMux) HandleFunc(pattern string, handler func(ResponseWriter, *Request)) {
  mux.Handle(pattern, HandlerFunc(handler))
}
```

This calls the `mux.Handle` method. Here is the signature of this method:

```go
func (mux *ServeMux) Handle(pattern string, handler Handler)
```

The last argument uses `HandlerFunc` type casting to translate the handler function into a type that implements the `Handler` interface.

The `Handler` interface looks like:

```go
type Handler interface {
  ServeHTTP(ResponseWriter, *Request)
}
```

`HandlerFunc` is a custom type:

```go
type HandlerFunc func(ResponseWriter, *Request)
```

And, it has one method:

```go
func (f HandlerFunc) ServeHTTP(w ResponseWriter, r *Request) {
	f(w, r)
}
```

This essentially calls the function when calling `ServeHTTP`.  So, the `HandlerFunc` type takes a function and then puts it into a format that can be used by the server mux.

#### Pipelining a set of adapter functions

You can chain multiple adapter functions to layer on more middleware.  Here is an example with logging and authentication, using the chaining of `Handler`s instead of `HandlerFunc`s.

```go
type HelloHandler struct{}

func (h *HelloHandler) ServeHTTP(writer http.ResponseWriter, request *http.Request) {
	fmt.Fprintf(writer, "Hello, World!")
}

func log(handler http.Handler) http.Handler {
	return http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		fmt.Println(time.Now(), " - called hello")
		handler.ServeHTTP(writer, request)
	})
}

func authenticate(handler http.Handler) http.Handler {
	return http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		// .. some authentication logic
		handler.ServeHTTP(writer, request)
	})
}

func main() {
	helloHandler := &HelloHandler{}
	mux := http.NewServeMux()
	mux.Handle("/", authenticate(log(helloHandler)))

	server := http.Server{
		Addr:    "127.0.0.1:8088",
		Handler: mux,
	}

	server.ListenAndServe()
}
```

Here we're wrapping the anonymous function returned by the adapter with the `http.HandlerFunc` typecast.  When this function is called, we then call the handler's `ServeHTTP` method.

## Request headers

The `http.Request` struct allows access to request headers.  You can get all the headers as a part of a map:

```go
func headerHandler(writer http.ResponseWriter, request *http.Request) {
	h := request.Header
	fmt.Fprintln(writer, h)
}

func main() {
	http.HandleFunc("/", headerHandler)
	http.ListenAndServe(":8088", nil)
}
```

Calling this with curl yields the following response body:

```text
map[User-Agent:[curl/7.43.0] Accept:[*/*]]
```

In this case, there are two headers `User-Agent` and `Accept`.

Calling this with Chrome:

```text
map[Upgrade-Insecure-Requests:[1] User-Agent:[Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36] Accept-Encoding:[gzip, deflate, sdch] Accept-Language:[en-US,en;q=0.8] Connection:[keep-alive] Accept:[text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8]]
```

You can also pull out individual headers:

```go
func headerHandler(writer http.ResponseWriter, request *http.Request) {
	h := request.Header
	fmt.Fprintln(writer, "all: ", h)

	userAgentRaw := h["User-Agent"]
	fmt.Fprintln(writer, "raw header: ", userAgentRaw)

	userAgentString := h.Get("User-Agent")
	fmt.Fprintln(writer, "string header: ", userAgentString)
}

func main() {
	http.HandleFunc("/", headerHandler)
	http.ListenAndServe(":8088", nil)
}
```

Calling with curl, we get:

```text
all:  map[User-Agent:[curl/7.43.0] Accept:[*/*]]
raw header:  [curl/7.43.0]
string header:  curl/7.43.0
```

Notice that the `h["User-Agent"]` approach returns the map value, which is a slice of entries.  The `Get` approach returns a string value.

## Getting the request body

#### Raw parsing of body data

The `Body` field of the `Request` struct is an implementer of the `io.ReadCloser` interface.  To read the body content, you need to use the `Read` function, which returns a byte slice, and then translate that into a string for printing.

```go
func bodyResponseHandler(writer http.ResponseWriter, request *http.Request) {
	body := make([]byte, request.ContentLength)
	request.Body.Read(body)
	fmt.Fprintln(writer, string(body))
}

func main() {
	http.HandleFunc("/", bodyResponseHandler)
	http.ListenAndServe(":8088", nil)
}
```

If you `curl` this, you get:

```bash
$ curl id "hello=world&foo=bar" http://localhost:8088
# HTTP/1.1 200 OK
# Date: Tue, 10 May 2016 14:29:10 GMT
# Content-Length: 20
# Content-Type: text/plain; charset=utf-8
#
# hello=world&foo=bar
```

#### Using `ParseForm` to get form data

Here is a simple handler that prints out the parsed form values that are submitted in the response body:

```go
func parsedFormHandler(writer http.ResponseWriter, request *http.Request) {
	request.ParseForm()
	fmt.Fprintln(writer, request.Form)

	for key, value := range request.Form {
		fmt.Fprintln(wrtier, key, "=", value)
	}
}

func main() {
	server := http.Server{Addr:":8088"}
	http.HandleFunc("/", parsedFormHandler)
	server.ListenAndServe()
}
```

And if you call this with `curl`:

```bash
$ curl -id "hello=world&foo=bar" http://localhost:8088
# HTTP/1.1 200 OK
# Date: Wed, 11 May 2016 14:30:48 GMT
# Content-Length: 29
# Content-Type: text/plain; charset=utf-8
#
# map[foo:[bar] hello:[world]]
# hello = [world]
# foo = [bar]
```

#### Getting form values with `FormValue`

The values are in the format `[]string`, most of them just containing a single string item.  But, it is possible for the value to be set more than once in a submitting form.  The `r.Form["name"]` value will return all of these values.  

In most cases, you just want the single string value.  You can access this with `r.FormValue("name")`.

```go
func helloHandler(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	fmt.Fprintf(w, "%#v\n", r.Form["name"])
	fmt.Fprintf(w, "%s\n", r.FormValue("name"))
}

func main() {
	server := http.Server{Addr: ":8088"}
	http.HandleFunc("/", helloHandler)
	server.ListenAndServe()
}
```

Call this with `curl`:

```bash
$ curl -id "name=foo&name=bar" http://localhost:8088
# HTTP/1.1 200 OK
# Date: Mon, 16 May 2016 02:18:40 GMT
# Content-Length: 27
# Content-Type: text/plain; charset=utf-8
#
# []string{"foo", "bar"}
# foo
```

## Returning Status Codes

If you are returning an error code, you can use the `http.Error` method:

```go
func StatusHandler(writer http.ResponseWriter, request *http.Request) {
	http.Error(writer, http.StatusText(http.StatusTeapot), http.StatusTeapot)
}
```

The `http` package has named variables that represent the various status codes, which can make your code easier to read.  There is also a `StatusText` method which returns standard status messages.

You could also do this with the writer's `WriteHeader` and `Write` methods:

```go
func StatusHandler(writer http.ResponseWriter, request *http.Request) {
	writer.WriteHeader(http.StatusTeapot)
	writer.Write([]byte("I'm a teapot\n"))
}
```

... or a good response:

```go
func StatusHandler(writer http.ResponseWriter, request *http.Request) {
	writer.WriteHeader(http.StatusOK)
	writer.Write([]byte("Hello, World!\n"))
}
```

Another common scenario is to check if an error is nil, and if not, return a 500 error with the message:

```go
if err != nil {
	http.Error(writer,·err.Error(),·http.StatusInternalServerError)
}
```

## Serving an HTML response with `Write`

The response writer `Write` method takes in a `[]byte` and writes it to the response body.

```go
func writeBodyHandler(w http.ResponseWriter, r *http.Request) {
	html := `<html>
	<head>
	  <title>Hello</title>
	</head>
	<body>
		<h1>Hello World!</h1>
		<p>Foo</p>
	</body>
</html>`
	w.Write([]byte(html))
}

func main() {
	http.HandleFunc("/", writeBodyHandler)
	server := http.Server{Addr: ":8088"}
	server.ListenAndServe()
}
```

## Creating a CRUD Resourceful Route System

Data piece that supports the routes:

```go
import (
	"database/sql"

	_ "github.com/lib/pq"
)

var Db *sql.DB

func init() {
	var err error
	Db, err = sql.Open(
		"postgres",
		"user=gosql_user password=secret dbname=gosql sslmode=disable",
	)
	if err != nil {
		panic(err)
	}
}

func getPost(id int) (post Post, err error) {
	post = Post{}
	sql := `
		SELECT
			id, content, author
		FROM
			posts
		WHERE
			id = $1
	`
	row := Db.QueryRow(sql, id)
	err = row.Scan(&post.ID, &post.Content, &post.Author)
	return
}

func (post *Post) create() (err error) {
	sql := `
		INSERT INTO posts
			(content, author)
		VALUES
			($1, $2)
		RETURNING
			id
	`
	statement, err := Db.Prepare(sql)
	if err != nil {
		return
	}
	defer statement.Close()
	row := statement.QueryRow(post.Content, post.Author)
	err = row.Scan(&post.ID)
	return
}

func (post *Post) update() (err error) {
	sql := `
		UPDATE
			posts
		SET
			content = $2,
			author = $3
		WHERE
			id = $1
	`
	_, err = Db.Exec(sql, post.ID, post.Content, post.Author)
	return
}

func (post *Post) delete() (err error) {
	sql := `
		DELETE FROM
			posts
		WHERE
			id = $1
	`
	_, err = Db.Exec(sql, post.ID)
	return
}
```

Notice that the `"github.com/lib/pq"` is not used directly but imported in order to call through to its `init` method.

Here is the multiplexer piece that handles the routes:

```go
type Post struct {
	ID      int    `json:"id"`
	Author  string `json:"author"`
	Content string `json:"content"`
}

func main() {
	server := http.Server{Addr: ":8088"}
	http.HandleFunc("/posts/", requestHandler)
	server.ListenAndServe()
}

func requestHandler(writer http.ResponseWriter, request *http.Request) {
	var err error
	switch request.Method {
	case "GET":
		err = handleGet(writer, request)
	case "POST":
		err = handlePost(writer, request)
	case "PUT":
		err = handlePut(writer, request)
	case "DELETE":
		err = handleDelete(writer, request)
	}
	if err != nil {
		http.Error(writer, err.Error(), http.StatusInternalServerError)
	}
}

func handleGet(writer http.ResponseWriter, request *http.Request) (err error) {
	id, err := strconv.Atoi(path.Base(request.URL.Path))
	if err != nil {
		return
	}
	post, err := getPost(id)
	if err != nil {
		return
	}
	postJSON, err := json.MarshalIndent(&post, "", "\t")
	if err != nil {
		return
	}
	writer.Header().Set("Content-Type", "application/json")
	writer.Write(postJSON)
	return
}

func handlePost(writer http.ResponseWriter, request *http.Request) (err error) {
	len := request.ContentLength
	body := make([]byte, len)
	request.Body.Read(body)
	fmt.Printf("%#v\n", request.Body)
	var post Post
	json.Unmarshal(body, &post)
	fmt.Printf("%#v\n", post)
	err = post.create()
	if err != nil {
		return
	}
	writer.WriteHeader(200)
	return
}

func handlePut(writer http.ResponseWriter, request *http.Request) (err error) {
	id, err := strconv.Atoi(path.Base(request.URL.Path))
	if err != nil {
		return
	}
	post, err := getPost(id)
	if err != nil {
		return
	}
	len := request.ContentLength
	body := make([]byte, len)
	request.Body.Read(body)
	json.Unmarshal(body, &post)
	err = post.update()
	if err != nil {
		return
	}
	writer.WriteHeader(200)
	return
}

func handleDelete(writer http.ResponseWriter, request *http.Request) (err error) {
	id, err := strconv.Atoi(path.Base(request.URL.Path))
	if err != nil {
		return
	}
	post, err := getPost(id)
	if err != nil {
		return
	}
	err = post.delete()
	if err != nil {
		return
	}
	writer.WriteHeader(200)
	return
}
```

## Exercises

* Request a webpage and print out the status, status code, content length, headers, the request URI and the body.
* Create a query string and post it to a URL.
* Post a request to a URL with a JSON body and print out the response body (don't forget to correctly set the header).
* Create a webserver on `8088` that responds with a single handler for all requests (use a custom response handler object).
* Create custom handler objects that respond to the routes `http://localhost:8088/hello` with the text "hello", and `http://localhost:8088/world` with "world" (use custom response handler objects).
* Update the previous exercise to use functions instead of custom response handler objects.
* Wrap a handler function with logging functionality.
* Add an authentication wrapper function to the previous example, so the handler is wrapped with both authentication and logging functionality (the authentication method doesn't have to function, it can just print out something).
* Print out the user agent request header.
* Handle the URL `http://localhost:8088/users/:id`, where ":id" is a random integer.  Parse and print out the integer.
* Read form values from a request and print them out.
* Serve a "hello world" HTML page, with a valid HTML skeleton and the words "hello world" in an `H1` tag.
