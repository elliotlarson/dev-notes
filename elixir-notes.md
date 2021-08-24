# Elixir Notes

## Mix

Mix is kind of like Ruby's Rake tool, providing an automated tasks runner.

Creating a new basic project:

```bash
$ mix new my_project
```

To compile this project:

```bash
$ elixir lib/my_project.ex
```

## IEX

An interactive shell, like Ruby's IRB.

Running a shell with a file loaded:

```bash
$ iex lib/my_project.ex
```

To get out of IEX, just `ctrl + c` twice.

You can also start IEX with the app loaded with:

```bash
$ iex -S mix
```

When you are in IEX you can reload a module if you update it with:

```bash
iex> r MyModule
```

There are a number of helper functions made available to you in IEX. To view them:

```bash
iex> h
```

If you are using IEX, you update and file, and you want IEX to have access to the update, you can use `recompile`:

```bash
iex> recompile()
```

## Functions

You can write multiple functions with the same name and arity and the system will use matching:

```elixir
def route(conv) do
  route(conv, conv.method, conv.path)
end

def route(conv, "GET", "/wildthings") do
  %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
end

def route(conv, "GET", "/bears") do
  %{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
end

def route(conv, _method, path) do
  %{ conv | status: 404, resp_body: "No #{path} here!"}
end
```

Here the first method calls one of the following three depending on the values.

Note that the arguments can be either variables or values used for direct matching. The middle two functions have specific routes, whereas the last function is a catchall.

Also, note that the final method needs to come last. Execution is order dependent. If you move the last method first, you'll see a warning about the fact that the other two methods will never be called.

You'll also see a warning if you don't group the functions with the same name together in a module.

Functions can be on one line, like so:

```elixir
def say_hi(name), do: IO.puts("Hello, #{name}")
```

You can also define conditionals in the function definition:

```elixir
def guess(a, b) when a > b, do: guess(b, a)
```

You can't stick function calls inside of the when clause, so adding something like `String.length(name)` wouldn't work.

### Private functions

You can create functions only accessible inside the module using `defp`.

```elixir
defp status_reason(code) do
  %{
    200 => "OK",
    201 => "Created",
    401 => "Unauthorized",
    403 => "Forbidden",
    404 => "Not Found",
    500 => "Internal Server Error",
  }[code]
end
```

## Strings

Strings are immutable, like everything else in Elixir, but you can create something like concatenation with the `<>` operator:

```bash
iex> "/bears/" <> "1"
"/bears/1"
```

You can also use a sigil if your string is going to contain quotes:

```elixir
~s("foo", "bar", "baz")
```

You can do string interpolation like in Ruby:

```elixir
name = "Bob"
IO.puts "Hello, #{name}"
```

The `String` module has a number of methods to help work with strings:

```elixir
String.length("Oh, what?")
# 9
```

You can do `heredocs` in Elixir, like in Ruby, but with `"""`:

```elixir
count_down = """
three
two
one
blastoff
"""
```

## Lists

Lists are implemented as linked lists.  This means that it is inexpensive to prepend an item to a list and expensive to append.  This is because prepending only involves creating a new item and linking it to the previous first item in the list.  Appending means adding a new item to the end and updating the last item to reference it.  Data is immutable, so this means replacing the previous last item with a new item having the link to the new last item.  When the item is updated, the item before it also needs to be "updated" to point to the new item.  This "updating", or creating of new items happens all the way up the linked list change, so it is an O(n) operation, whereas prepending is an O(1).

Lists are created with square brackets:

```elixir
arr = [1, 2, 3, 4]
```

Prepending to a list:

```elixir
arr2 = [0 | arr]
# [0, 1, 2, 3, 4]
```

Appending (even though this is inefficient)

```elixir
arr3 = arr2 ++ [5]
# [0, 1, 2, 3, 4, 5]
```

Checking if an item is in an array:

```elixir
1 in arr3
# true
10 in arr3
# false
```

Getting the length of a list:

```elixir
length(arr3)
# 6
```

Retrieving a list item at index (this is an O(n) operation because the list needs to be traversed to find the item):

```elixir
Enum.at(arr3, 2)
# 2
```

You can grab the first 3 items of a list with:

```elixir
[r, g, b | _tail] = arr3
# r = 0, g = 1, b = 2
```

You can iterate over a list and modify each element with `map`:

```elixir
Enum.map(["one", "two", "three"], fn x -> String.upcase(x) end)
# ["ONE", "TWO", "THREE"]
```

If you are inside a module and you want to use a module function, you can by referencing the method like so `&method_name/1` (leading `&` and followed by method arity `/n`):

```elixir
defmodule MyModule do
  def some_method(list) do
    list
    |> Enum.map(&upcase/1)
  end

  def upcase(string) do
    String.upcase(string)
  end
end
```

## Maps

These are like hashes in Ruby.  They have better access performance than lists, but are less efficient for access than tuples.

Maps are unordered.

You can use anything as a key in a map, but it's most common to use atoms or strings:

```elixir
user = %{name: "Elliot", email: "foo@example.com"}
user = %{"name" => "Elliot", "email" => "foo@example.com"}
```

Atoms are not garbage collected, so when you are creating maps with an arbitrary number of keys, especially when working with dynaimc data, it can be safer to use strings.

You can access values for keys like in Ruby:

```elixir
user[:email]
user["email"]
```

However if you use an atom as a key, you can use the dot syntax for access:

```elixir
user.email
```

You can get a list of keys for a map:

```elixir
Map.keys(user)
```

And, you can get a list of values:

```elixir
Map.values(user)
```

You can update a value and return a new map with:

```elixir
Map.put(user, :name, "Foobar")
# or
%{user | name: "Foobar"}
```

You can remove keys and return a new map:

```elixir
Map.drop(user, [:email])
```

You can merge items in and return a new map:

```elixir
Map.merge(user, %{admin: true})
```

## Pattern matching

When matching maps you can match partial key value sets:

```elixir
%{ method: "GET" } = %{ method: "GET", path: "/wildlife" }
```

This matches on "GET".

You can also bind to a variable in a match:

```elixir
%{ method: method, path: "/wildlife" } = %{ method: "GET", path: "/wildlife" }
```

Now the variable `method` is bound to "GET".

You can also pattern match a subset of a map:

```elixir
request = %{ method: "GET", path: "/wildlife" }
%{ path: path } = request
path
# "/wildlife"
```

## Aliases

You can alias a module name to keep things shorter:

```elixir
defmodule Servy.Parser do
  alias Servy.Conv, as: Conv
end
```

Then you can use `Conv` in your module.

There's also a shorthand for this:

```elixir
defmodule Servy.Parser do
  alias Servy.Conv
end
```

## Creating a simple app and trying it out

Here is a simple greeter module.

```elixir
defmodule Greeter do
  def say_hi do
    name = IO.gets("What's your name?\n")
    greet(String.trim(name))
  end

  def greet("Elliot") do
    IO.puts("Hey, Elliot! That's a great name!")
    whats_your_nickname()
  end

  def greet(name) do
    IO.puts("Hey, #{name}.  Nice to meet you.")
    whats_your_nickname()
  end

  def whats_your_nickname do
    nickname = IO.gets("What's your nickname?\n")
    IO.puts("Yo, #{String.trim(nickname)}.")
  end
end
```

Save this in a file named `greeter.ex`.

Then enter an IEX session, compile the file, and use it:

```bash
$ iex
iex> c "greeter.ex"
# [Greeter]
iex> Greeter.say_hi
# What's your name?
# Elliot
# Hey, Elliot! That's a great name!
# What's your nickname?
# Dude
# Yo, Dude.
# :ok
```

## Hashing Strings

```elixir
hash = :crypto.hash(:md5, "banana")
Base.encode16(hash)
```
