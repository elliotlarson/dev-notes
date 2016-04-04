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
