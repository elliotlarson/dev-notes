# Golang Bytes Notes

Most strings in Go are dealt with as byte slices `[]byte`. [Here's some further information](https://blog.golang.org/strings) from the Go blog about this.

## Building up a string with `bytes.Buffer`

The `bytes.Buffer` type implements the `io.Writer` interface and provides some convenience methods for working with a slice of bytes.

You can create a empty bytes buffer:

```go
buf := new(bytes.Buffer)
```

And then you can write to it:

```go
buf.Write([]byte("Hello, World!"))
```

Or, you could write this:

```go
var buf bytes.Buffer
&buf.Write([]byte("Hello, World!"))
```

In these examples, we are casting the strings to `[]byte` so we can use the `Write` method.  You can also use strings directly with the `WriteString` method.

```go
var buf bytes.Buffer
buf.WriteString("Hello, World!")
```

And then we can get the string with the `String` method so we can print it out:

```go
fmt.Println(buf.String())
```

You can use the `fmt` package to print out the value, but you can also write the contents of a `bytes.Buffer` to an `io.Writer` with the `WriteTo` method (here we're using `os.Stdout` as our `io.Writer`).

```go
buf.WriteTo(os.Stdout)
```
