# Elixir ExUnit Notes

## Example test

ExUnit provides three main macros, `setup`, `test` and `assert`.

```elixir
defmodule MyTest do
  use ExUnit.Case, async: true

  setup do
    :ok
  end

  test "pass" do
    assert true
  end

  text "fail" do
    assert false
  end
end
```

The `async: true` flag allows tests in this module to run concurrently with tests defined in other modules.

## Running tests

Running all tests:

```bash
$ mix test
```

Running a test file:

```bash
$ mix test test/rumbl_web/controllers/page_controller_test.exs
```

Running a single test:

```bash
$ mix test test/rumbl_web/controllers/page_controller_test.exs:42
```
