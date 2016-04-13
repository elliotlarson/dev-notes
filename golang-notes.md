# Golang Notes

## Setting up

First, install Go:

```bash
$ brew install go
```

Then add in the `GOPATH` environment variable, and add the bin directory of the Go install to your path:

```bash
$ export GOPATH="$HOME/Work/GoCode"
$ export PATH="/usr/local/opt/go/libexec/bin:$GOPATH/bin:$PATH"
```

## Creating a "hello world" program

In your `$GOPATH` make a directory for your hello program:

```bash
$ mkdir -p $GOPATH/src/github.com/elliotlarson/hello/
```

Then inside of this create a `hello.go` file containing:

```go
package main

import "fmt"

func main() {
  fmt.Printf("Hello, Go!\n")
}
```

Then build and install the program:

```bash
$ go build
$ go install
```

This will generate an executable called `hello` and put it in your `$GOPATH/bin/` directory.  

Provided you have this directory included in your `$PATH`, you should be able to execute it:

```bash
$ hello
# => Hello, Go!
```

## Packages

In Go, code is organized into groups of files called packages.

All go files declare a package that they belong to as their first line.  For example, in the `hello` program, the `main.go` file has:

```go
package main
```

The `main` package is special and indicates to the Go compiler that the program is going to be an executable.  

The package `main` is accompanied by the function `main` that is the entrypoint for execution of an executable Go app:

```go
package main

func main() {
  // the stuff that runs when your app runs
}
```

If there is no `main` package the application is then a set of utlity packages meant for reuse in other programs.

For example, if you look at the `net/http` package from the standard library, it has no `main` package and its directory structure is:

```bash
net/http
  cgi
  cookiejar
    testdata
  fcgi
  httptest
  httputil
  pprof
  testdata
```

By convention, packages take the name of their directory, so this library has a `cgi` package and a `httptest` package.  You can have any number of files in a directory that belong to a package.  However, you may not have multiple packages in a directory.  One directory, one package.

#### Importing packages

To import a library from the standar go library, you just need to use it's name:

```go
import (
  "net/http" // actually looks in $GOPATH/src/pkg/net/http
)
```

You can also import remote packages:

```go
import "github.com/fatih/color"
```

If you don't have this file on your local system, you can import with `go get`:

```bash
$ go get github.com/fatih/color
```

The go compiler will look for a matching library in this order, quiting when it finds one that satisfies an import statement:

1. standard library location: $GOPATH/src/pkg
2. the current project: $GOROOT/src/your/project
3. the location of other Go packages on your system: $GOROOT/src/...

If you have a package that conflicts with the naming of a standard package, you can use a named import:

```go
import (
  "fmt"
  myfmt "mylib/fmt"
)
```

The Go compiler will fail if you have an import statement for a package that you don't use.  But, sometimes you still want to load a package to take advantage of the package's `init` functionality.  In this case, you can prefix the import with an underscore:

```go
import (
  _ "some/library/with/init/functionality"
)
```

#### Init functions

Init functions allow setup for packages to happen before the `main` function is run.  Each package can have as many `init` functions as it wants.  A good example of an `init` function is in the `postgres` package:

```go
package postgres

import (
  "database/sql"
)

func init() {
  sql.Register("postgres", new(PostgresDriver))
}
```

The registration of drivers with the `sql` package can't happen at compile time.  It needs to happen at execution time.

The `init` function is a great way to bootstrap stuff before a program executes.

## Variables

Go is strongly typed and when declaring variables you can do it explicitly:

```go
var message string
message = "Hello, World!"
```

... or, on one line:

```go
var message string = "Hello, World!"
```

Go also has a shortcut for this where it will infer the type during assignment:

```go
message := "Hello, World!"
```

When using this inference approach, you can specify the data type that you want:

```go
pi := float64(3.14)
```

If you use the short variable assignment syntax, you must assign at least one new variable.  So, this would cause an error:

```go
foo := "bar"
foo := "baz"
// compile error: no new variables
```

But, you can do:

```go
foo := "bar"
foo = "baz"
```

It is a common Go idiom to declare variables and use them in conditionals:

```go
if numChars, err := fmt.Printf("%s\n", "Hello, World!"); err != nil {
  os.Exit(1)
}
```

If the code executes without error, `numChars` will not exist outside the context of the if statement.  This will throw and error:

```go
if numChars, err := fmt.Printf("%s\n", "Hello, World!"); err != nil {
  os.Exit(1)
}
fmt.Printf("%d\n", numChars)
// => /path/to/myfile.go:line undefined numChars
```

You could rewrite this like this:

```go
if numChars, err := fmt.Printf("%s\n", "Hello, World!"); err != nil {
  os.Exit(1)
} else {
  fmt.Printf("%d\n", numChars)
}
// => 13
```

#### Pointers

A variable is a piece of storage containing a value.  A pointer value is the address of a variable.  It's the location at which the value is stored.

Say you have the variable assignment:

```go
x := 1
p := &x
fmt.Println(*p)
// 1
*p = 2
fmt.Println(x)
// 2
```

The expression `&x` (address of `x`) yields a pointer to the integer value 1, that is a value of type `*int`.  The `&` operator is called the **address of operator**.  With our next assignment, we are saying **"p points to x"** or **"p contains the address of x"**.  To print the value 1, we need to "dereference" `p` with `*p`.  We can also set the underlying value of `x` through `p` with `*p = 2`, which is **"assign the value that p points to to 2"**.

Say you have the following code:

```go
func incr(p *int) int {
  *p++
  return *p
}

func main() {
  v := 1
  incr(&v)
  fmt.Println(incr(&v))
}
```

If you run a debug session with a breakpoint after the `v` variable assignment:

```bash
(dlv) p v
# 1
(dlv) p &v
# (*int)(0x8201fbef8)
(dlv) p *v
# expression "v" (int) can not be dereferenced
```

#### New function

Executing `new(T)` creates a variable of type `T`, initializes it to its zero value, and returns its address (or `*T`).

```go
p := new(int)
fmt.Println(*p)
// 0
```

#### The blank `_` identifier

Go will throw a compile error if you declare a variable that you don't use.  However, sometimes you need to assign a variable you don't intend to use.  In these cases, you can use the `_` identifier.

```go
_, err := io.Copy(dst, src)
```

## Strings

You can pull out substrings:

```go
message := "The quick brown fox jumps over the lazy dog"
fmt.Printf("%s\n", message[0:19])
// => The quick brown fox
fmt.Printf("%s\n", message[16:19])
// => fox
```

If you use backticks instead of quotes, the string is treated literally (notice how the `\n` gets printed:

```go
message := `The quick brown "fox" jumps over the lazy dog\n`
fmt.Printf("%s\n", message)
// => The quick brown "fox" jumps over the lazy dog\n
```

You can concatenate strings:

```go
"foo" + " " + "bar"
// => foo bar
```

## Control flow

Go has the traditional if statement constructs:

```go
if value > 10 {
  fmt.Println("It's greater than 10")
} else if value < 2 {
  fmt.Println("It's less than 2")
} else {
  fmt.Println("It's between 2 and 10")
}
```

Go has a switch statement, that can be used like this without a value comparison to kick it off:

```go
switch {
case value > 10:
  fmt.Println("It's greater than 10")
case value < 2:
  fmt.Println("It's less than 2")
default:
  fmt.Println("It's between 2 and 10")
}
```

Or, you can switch on a variable:

```go
switch value {
case 10, 11, 12:
  fmt.Println("It' 10, 11, or 12")
case 2:
  fmt.Println("It's 2")
default:
  fmt.Println("It's not 2, 10, 11, or 12")
}
```

## Looping

Go only has one kind of loop, the `for` loop.  You can write it in different ways to achieve different effects.

Here is an infinite loop:

```go
for {
  fmt.Printf(".")
}
```

Iterate a certain number of times:

```go
count := 0
for count < 10 {
  fmt.Printf(".")
  count += 1
}
```

Or, you can use a more standard C-style for loop:

```go
for count := 0; count < 10; count += 1 {
  fmt.Printf(".")
}
```

But, this construct will allow you to add in more statements than a for loop in C:

```go
for i, j := 0, 1; i < 10; i, j = i+1, j*2 {
  fmt.Printf("%d ", j)
}
```

And, you can you `for` like a traditional `while` loop:

```go
var stop bool // false is the zero value of a bool
count := 0
for !stop {
  fmt.Printf(".")
  count++
  if count == 10 {
    stop = true
  }
}
```

You can `break` out of a loop:

```go
limit := 10
i := 0
for {
  fmt.Println("Hello, World!")
  if i == limit {
    break
  }
}
```

You can `continue` to the next iteration of a loop:

```go
for i := 0; i < 10; i++ {
  if i % 2 == 0 {
    continue
  }
  fmt.Println("Hello, World! ")
}
```

## Functions 

Here is what a basic function looks like:

```go
func printer(msg string) {
  fmt.Printf("%s\n", msg)
}
printer("Hello, World!")
```

If you have multiple arguments of the same type, the go idiom is to group them:

```go
func printer(msg1, msg2 string, repeat int) {
  // ...
}
```

You can define a return type from a function:

```go
func printer(msg string) error {
  _, err := fmt.Printf("%s\n", msg)
  return err
}
```

You can also return multiple values from a function:

```go
func printer(msg string) (string, error) {
  _, err := fmt.Printf("%s\n", msg)
  printString := "OK"
  return printString, err
}
```

Go gives you the `defer` command to put off execution until a function has completed executing:

```go
func processFile(file string) {
  file, err := os.Open(file)
  if err != nil {
    os.Exit(1)
  }
  defer file.Close()
  // do some stuff with the file
}
```

You can also use named return parameters:

```go
func printer(msg string) (e error) {
  _, err := fmt.Printf("%s\n", msg)
  return
}
```

Notice that you don't have to add the variable to the return here.  Since you've named it, when you return from the function, Go knows you want to return the `e` variable.

Functions in Go can accept variable numbers of arguments:

```go
func printer(msgs ...string) {
  for _, msg := range msgs {
    fmt.Printf("%s\n", msg)
  }
}
```

## Arrays and Slices

Initializing an array with an unknown number of elements:

```go
words := [...]string{"the", "quick", "brown", "fox", "jumped", "over", "the", "lazy", "dog"}
```

If you know the number of items ahead of time, you can initialize like this:

```go
words := [9]string{"the", "quick", "brown", "fox", "jumped", "over", "the", "lazy", "dog"}
```

You can access array items in the standard way with the index number:

```go
fmt.Printf("%s\n", words[3])
// => fox
```

Arrays are copied and not passed around by reference which can have an impact on performance:

```go
func printer(words [9]string) {
  for _, word := range words {
    fmt.Printf("%s ", word)
  }
  fmt.Printf("\n")
}
printer(words)
```

When you pass the words array into the function, the array is copied.  So, modifying the array in the function will not change the original words array.  However, you've now doubled the amount of memory used for the array in the program, which can be expensive with a larger array.

More commonly, in Go you use the `slice`, which is a window into an underlying array.  Unlike arrays, slices are passed around by reference instead of copying.

To define the previous words array as a slice:

```go
words := []string{"the", "quick", "brown", "fox", "jumped", "over", "the", "lazy", "dog"}
```

To update the printer function to work with a slice instead of an array:

```go
func printer(words []string) {
  for _, word := range words {
    fmt.Printf("%s ", word)
  }
  fmt.Printf("\n")
}
```

You can create a slice of a slice:

```go
printer(words[0:2])
// => the quick
```

You can initialize a slice with the `make` command:

```go
words := make([]string, 4) // you need to initialize with some quantity
words[0] = "the"
words[1] = "quick"
words[2] = "brown"
words[3] = "fox"
printer(words)
// the quick brown fox
```

But, if we tried to add a 5th item in the same way, we'd get an error:

```go
words[5] = "jumped"
// => panic: runtime error: index out of range ...
```

You can use an alternate sytax to create a slice where you specify the number of items and the make length of the slice:

```go
words := make([]string, 0, 4)
```

This is, initialize the slice with zero items and only allow a maximum capacity of 4 items.



Then you can use the `append` method to add to the words slice:

```go
words = append(words, "the")
words = append(words, "quick")
words = append(words, "brown")
words = append(words, "fox")
words = append(words, "jumped")
printer(words)
// => the quick brown fox jumped
```

Notice that appending the 5th item does not raise an error.

You can use the `len` and `cap` methods to get the length and capacity of the slice:

```go
fmt.Printf("length: %d, capacity: %d\n", len(words), cap(words))
// => length: 5, capacity: 8
```

Notice how the capacity is 8 instead of 4.  When you added the 5th element to the slice, Go recognized that there was not enough space in slice.  So, it made a copy of it and doubled the capacity for the new copied slice.

You can manually copy a slice:

```go
newWords := make([]string, 0, 8)
copy(newWords, words)
```

## Maps

You can initialize/make a map like this:

```go
dayMonths := make(map[string]int)
dayMonths["Jan"] = 31
dayMonths["Feb"] = 28
dayMonths["Mar"] = 31
dayMonths["Apr"] = 30
dayMonths["May"] = 31
dayMonths["Jun"] = 30
dayMonths["Jul"] = 31
dayMonths["Aug"] = 31
dayMonths["Sep"] = 30
dayMonths["Oct"] = 31
dayMonths["Nov"] = 30
dayMonths["Dec"] = 31

fmt.Printf("Days in October: %d\n", dayMonths["Oct"])
// => Days in October: 31
```

You can also use a shorter form:

```go
dayMonths := map[string]int{
  "Jan": 31,
  "Feb": 28,
  "Mar": 31,
  "Apr": 30,
  "May": 31,
  "Jun": 30,
  "Jul": 31,
  "Aug": 31,
  "Sep": 30,
  "Oct": 31,
  "Nov": 30,
  "Dec": 31,
}
```

If you access an element of a map that does not exist it returns the zero value of the map's value type:

```go
fmt.Printf("Days in October: %d\n", dayMonths["October"])
// => Days in October: 0
```

Here it returned the zero value of an `int` which is `0`.

If you want to figure out if the item actually doesn't exist, you can use the `okay` syntax:

```go
daysInOctober, ok := dayMonths["October"]
if !ok {
  fmt.Printf("The days for October were not found\n")
}
```

You can iterate over maps:

```go
for month, days := range dayMonths {
  fmt.Printf("There are %d days in %s\n", days, month)
}
```

**Note:** the order of maps is not reliable.  If order is important, you can sort the map.

You can remove an item from a hash with `delete`:

```go
delete(dayMonths, "Feb")
```

## Byte Slices

Byte slices are common in Go because a lot of the IO packages read data in from sources using this type of slice.

For example, when you read a file:

```go
file, err := os.Open("myfile.txt")
if err != nil {
  fmt.Printf("%s\n", err) // err gets converted into a string by Printf
  os.Exit(1)
}
defer file.Close()

byteSlice := make([]byte, 100)
numberBytesRead, err := file.Read(byteSlice)
stringVersion := string(byteSlice)
fmt.Printf("%s\n", stringVersion)
```

Notice that in order to print out the string we had to convert the byte slice into a string.

We can also convert a string to a byte slice, like we would need to do to write to a file:

```go
msg := "Some text to write to a file"
file.Write([]byte(msg))
```

## Error Handling

You can return an error with the `fmt` library:

```go
func errorProducer(msg string) error {
  if msg == "" {
    return fmt.Errorf("Hey that message was empty.")
  } 
}

if error := errorProducer(""); error != nil {
  fmt.Printf("ERROR: %s\n", error)
}
```

This is a useful way to produce error messages if you don't need to figure out at some later time what kind of error it was.  In other words, if you just need a quick error message.

If you want something a little more like a standard error, you can use the errors package:

```go
var errorEmptyMessage = errors.New("Hey that message was empty.")

func errorProducer(msg string) error {
  if msg == "" {
    return errorEmptyMessage
  } 
}

if error := errorProducer(""); error != nil {
  if error == errorEmptyMessage {
    fmt.Printf("EMPTY MESSAGE ERROR: %s\n", error)
  } else {
    fmt.Printf("ERROR: %s\n", error)
  }
}
```

If you want to end program execution when an error occurs, you can use `panic`, although it is more advisable to catch standard errors and deal with them in your code:

```go
func errorProducer(msg string) error {
  if msg == "" {
    panic("Hey that message was empty.")
  } 
}

errorProducer("")
```

This will cancel execution of the Go program and give a stack trace.

## User defined types

The most common way to define a custom type in Go is to use a `struct`:

```go
type user struct {
  first_name string
  last_name string
  email string
  admin bool
}
```

You can use this type in a couple of ways:

```go
elliot := user{
  first_name: "Elliot",
  last_name: "Larson",
  email: "elliot@onehouse.net",
  admin: true,
}

// or

elliot := user{"Elliot", "Larson", "elliot@onehouse.net", true}
```

You can also use user defined types when setting struct types:

```go
type admin struct {
  level int
}

type user struct {
  name string
  admin admin
}

elliot := user{
  name: "Elliot Larson",
  admin: admin{
    level: 1,
  },
}
```

You can also create types that are based on existing types.  

```go
type Duration int64
```

This can be useful if you want to attach applicationn specific functionality or meaning to a standard type.

You can add behavior to user defined types with methods:

```go
type user struct {
  firstName string
  lastName string
}

func (user user) fullName() string {
  n := []byte{user.firstName, user.LastName}
  return strings.Join(n, " ")
}

func main() {
  elliot := user{
    firstName: "Elliot",
    lastName: "Larson",
  }
  fmt.Printf("Full name: %s", elliot.fullName())
}
// => Full name: Elliot Larson
```

However, lets say you had a method that modified the data in the `user` struct:

```go
func (user user) setFirstName(newFirstName string) {
  user.firstName = newFirstName
}

func main() {
  elliot := user{
    firstName: "Elliot",
    lastName: "Larson",
  }
  fmt.Printf("Full name: %s", elliot.fullName())
  elliot.setFirstName("El")
  fmt.Printf("Full name: %s", elliot.fullName())
}
// => Full name: Elliot Larson
// => Full name: Elliot Larson
```

Notice that both `Printf` statements output the same value, even though we changed the `firstName` value.  This is because the user struct is being passed by value (copied) into each method instead of passing by reference.

To fix this, we need to use pointers:

```go
type user struct {
  firstName string
  lastName string
}

func (user user) fullName() string {
  n := []byte{user.firstName, user.LastName}
  return strings.Join(n, " ")
}

func (user *user) setFirstName(newFirstName string) {
  user.firstName = newFirstName
}

func main() {
  elliot := &user{
    firstName: "Elliot",
    lastName: "Larson",
  }
  fmt.Printf("Full name: %s", elliot.fullName())
  elliot.setFirstName("El")
  fmt.Printf("Full name: %s", elliot.fullName())
}
// => Full name: Elliot Larson
// => Full name: El Larson
```

Go is somewhat forgiving here, translating pointers and values into the appropriate thing a method expects, so this can be a bit confusing.  If you plan to mutate a value, use a pointer.  If you don't care about maintaining the state of a mutation, use a value.

## Debugging with Delve

[Delve](https://github.com/derekparker/delve) (dlv) is a full featured, community developed Go debugger. 

#### Installation

The installation instructions are a little hard to follow.  Basically, you start by getting the code:

```bash
$ go get github.com/derekparker/delve
```

This grabs the code from GitHub and puts it in the `$GOPATH/src/github.com/derekparker/delve` directory.

Then you generate a self signed certificate using the Keychain Access application.  This is more complicated than it should be.  (Long-winded instructions are here.)[https://github.com/derekparker/delve/wiki/Building].

Once you have the certificate in place, you need to `make` the delve binary:

```bash
$ cd $GOPATH/src/github.com/derekparker/delve
$ GO15VENDOREXPERIMENT=1 CERT=dlv-cert make install
```

#### Usage

Lets say you have the following code in `main.go`:

```go
package main

import (
  "fmt"
  "os"
)

func main() {
  var s, sep string
  for i := 1; i < len(os.Args); i++ {
    s += sep + os.Args[i]
    sep = " "
  }
  fmt.Println(s)
}
```

In the same directory as `main.go`, enter the following:

```bash
$ sudo dlv debug -- foo bar baz
# Type 'help' for list of commands.
(dlv) b main.go:18
(dlv) c
# > main.main() ./main.go:18 (hits goroutine(1):1 total:1) (PC: 0x20a2)
#     13: )
#     14:
#     15: func main() {
#     16:         var s, sep string
#     17:         for i := 1; i < len(os.Args); i++ {
# =>  18:                 s += sep + os.Args[i]
#     19:                 sep = " "
#     20:         }
#     21:         fmt.Println(s)
#     22: }
#     23:
(dlv) p os.Args
# => []string len: 4, cap: 4, ["./debug","foo","bar","baz"]
(dlv) p os.Args[1]
# "foo"
(dlv) p i
# 1
(dlv) c
# > main.main() ./main.go:18 (hits goroutine(1):2 total:2) (PC: 0x20a2)
#     13: )
#     14:
#     15: func main() {
#     16:         var s, sep string
#     17:         for i := 1; i < len(os.Args); i++ {
# =>  18:                 s += sep + os.Args[i]
#     19:                 sep = " "
#     20:         }
#     21:         fmt.Println(s)
#     22: }
#     23:
(dlv) p i
# 2
# ctrl-d to exit
```

If you are debugging an application that doesn't take in command line arguments the command to start a debugging session is:

```bash
$ sudo dlv debug
```

In our case, we *do* want command line arguments, so we append `-- arg1 arg2 arg2`.

Once the debugging session is started, we set breakpoints.  We did this with `b main.go:18`.  This tells dlv to set a breakpoint at line 18 in the `main.go` file.  

Once we're done setting breakpoints, we tell dlv to execute throught to the first breakpoint with the continue command `c`.

When dlv hits a breakpoint, it prints out the code's context and allows you to poke around.  To look at variables, use the print command.  In our case, we looked at the args being passed in with `p os.Args`.

Once you're finished with your debugging session, you can `ctrl-d` to quit.

## Testing

Go has a testing package in its standard library.  Here is a basic, trivial test:

```go
package my_first_test

import "testing"

func TestMyFirstTest(t *testing.T) {
  if 1 != 2 {
    t.Errorf("An error occured")
  }
}
```

Test functions all start with the prefix `Test` and accept the argument `t *testing.T`.  The text after the prefix `Test` in the function name is up to you and should be descriptive about the nature of the test (maybe something better than `MyFirstTest`.

`*testing.T` provides a number of methods for use in your tests. If you call `t.Error` or `t.Errorf`, the test runner will register a failure with the message supplied.  The errors will be printed out as they occur when the test suite is run.  If you use `t.Fatal` or `t.Fatalf` the error will be printed out and the suite will stop running. 

Go tests generally have the same name as the file they are testing, but the filename is postfixed with `_test.go`.  The test also generally belongs to the same package as the file under test. 

Here's a trivial example:

Say we have an implementation file `simplemath/math.go`:

```go
package simplemath

func IntAdd(a, b int) int {
  return a + b
}
```

Then we could have a test file `simplemath/math_test.go`:

```go
package simplemath

import "testing"

func TestIntAdd(t *testing.T) {
  c := IntAdd(2, 2)
  if c != 4 {
    t.Errorf("Expected result to eq %d, but received %d", 4, c)
  }
}
```

#### Running tests

You can run all tests from the root of the codebase with:

```bash
$ go test
# PASS
# ok      github.com/elliotlarson/simplemath      0.005s
```

You can also use the `-v` option to get verbose output:

```bash
$ go test -v
# === RUN   TestIntAdd
# --- PASS: TestIntAdd (0.00s)
# PASS
# ok      github.com/elliotlarson/simplemath      0.005s
```

To run a specific file, you can pass in the filename as an argument:

```bash
$ go test math_test.go
# command-line-arguments
# ./math_test.go:6: undefined: IntAdd
# FAIL    command-line-arguments [build failed]
```

We failed here because the implementation file was not included.  To fix this problem, add the implementation filename too:

```bash
$ go test math_test.go math.go
# ok      command-line-arguments  0.005s
```

You can also run specific tests identified by a regex using the `-run` argument to identify matching test names:

```bash
$ go test -v -run 'IntAdd' math_test.go math.go
# === RUN   TestIntAdd
# --- PASS: TestIntAdd (0.00s)
# PASS
# ok      command-line-arguments  0.006s
```

#### Debugging tests with Delve

To start a testing debug session:

```bash
$ sudo dlv test
(dlv) b math_test.go:8
# Breakpoint 1 set at 0x7df2f for _/Users/Elliot/Work/GoCode/src/github.com/elliotlarson/simplemath.TestIntAdd() ./math_test.go:8
(dlv) c
# > _/Users/Elliot/Work/GoCode/src/github.com/elliotlarson/simplemath.TestIntAdd() ./math_test.go:8 (hits goroutine(5):1 total:1) (PC: # 0x7df2f)
#      3: import "testing"
#      4:
#      5: func TestIntAdd(t *testing.T) {
#      6:         c := IntAdd(2, 2)
# =>   7:         if c != 4 {
#      8:                 t.Errorf("Expected result to eq %d, but it was %d", 4, c)
#      9:         }
#     10: }
#     11:
(dlv) p c
# 4
```
