# GoLang Notes

## Basic Hello World

In file named `hello.go`

```golang
package main

import "fmt"

func main() {
  fmt.Println("Hello, World!")
}
```

## Variables

#### Assigning with a type:

```golang
var myString string
myString = "Foo"
```

or, on one line:

```golang
var myString string = "Foo"
```

#### or, Go can intuit the type based on the value:

```golang
myString := "Foo"
```

## Concatinating Strings

```golang
"foo" + " " + "bar"
```

## Arrays and Slices

#### Assign an array like so:

```golang
words := [...]string{"the", "quick", "brown", "fox"}
```
The array can only be the length specified during initialization.

Arrays are also copied around instead of being passed around by reference.

**ARRAYS ARE RARELY USED**

#### Assign a slice like so:

```golang
words := []string{"the", "quick", "brown", "fox"}
```

#### You can slice a slice like so (grabbing the third word to the end):

```golang
wordsSlice = words[2:]
```

#### find the length of a slice:

```golang
len(words)
```

#### Add an item to a slice:

```golang
words = append(words, "foo")
```

When using append, if you are adding more than the initial capacity
of the slice, then Go will automatically increase the capacity of the
slice and then add the item.

#### Make an empty slice:

```golang
words = make([]string)
```

## Iteration with Arrays and Slices

#### Iterate over a collection:

```golang
for i, word := range words {
  fmt.Println("Word %s is number %d", word, i)
}
```

#### Do an endless loop:

```golang
for {
  fmt.Println("Hello, World!")
}
```

#### Exit a loop on a condition:

```golang
limit := 10
i := 0
for {
  fmt.Println("Hello, World!")
  if i == limit {
    break
  }
}
```

#### Proceed to the next iteration of a loop on condition:

```golang
for i := 0; i < 10; i++ {
  if i % 2 == 0 {
    continue
  }
  fmt.Println("Hello, World! ")
}
```

#### Doing multiple assignments on interator setup:

```golang
for i, j := 0, 2; i < 10; i++, j*2 {
  if i % 2 == 0 {
    continue
  }
  fmt.Println("Hello, World!")
}
```

## Maps

These are like associative arrays, dictionaries, hashes, etc.

#### Make an empty map

```golang
months := make(map[string]int)
```

#### start a map with predefined values

```golang
months := map[string]string{
  "Jan": 31,
  "Feb": 28,
  ...
}
```

#### assigning value

```golang
months["Jan"] = 31
```

#### getting a value back out that doesn't exist

```golang
months["January"]
// => 0
```

this equals zero because it takes the zeroth value for the map's value type.
In this case the value type is an integer, and so it returns 0.

This will allow you to make calls for map items that don't exist without
causing a runtime error.

#### telling the difference between the zeroth value and an actual zero value

say you have a map item with the int value of zero.  How do you tell the
difference between that zero and the zero returned when no value is found?

```golang
days, ok := months["January"]
```

the ok value is a boolean.  If the value is found, then ok will be true,
if the value is not found the value will be set to false.

#### deleting an item from a map

```golang
delete(months, "Jan")
```

It's okay to delete an item that does not exist.  Go will not complain.

## Iterating over a Map

```golang
for key, value := range months {
  fmt.Println("%s has %d days in it", key, value)
}
```

## Functions

#### a function that takes no arguments and returns nothing

```golang
func foo() {
  // do some stuff
}
```

#### a function that takes an argument

```golang
func foo(name string) {
  fmt.Printf("%s\n", name)
}
```

#### a function that returns a value

```golang
func greetingGetter(name string) string {
  return "Hello, " + name + "!"
}
```

#### a function with a named return

```golang
func greetingGetter(name string) (greeting string) {
  greeting = "Hello, " + name + "!"
  return
}
```

#### function with variadic arguments 

```golang
func greetingGetter(names ...string) (greeting string) {
  greeting = "Hello"
  for _, name := range names {
    greeting = greeting + ", " + name
  }
  greeting = greeting + "!"
}

greetingGetter("Billy", "Bob")
```

#### function with multiple returns

```golang
func greetingGetter(name string) (formal string, informal string) {
  formal = "Hello, " + name + "!"
  informal = "Yo, " + name + "!"
  return
}

formal, informal := greetingGetter("Elliot")
```

