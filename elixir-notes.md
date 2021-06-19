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
