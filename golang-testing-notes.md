# Golang Testing Notes

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

## Running tests

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

## Logging during tests

Because Go lacks the kind of easy-to-use debugging environment that Ruby has, it may be easiest to debug tests with `t.Log`.  This outputs information to the test runner's output (standard out).

```go
func TestLoggingDuringTest(t *testing.T) {
	t.Log("*** debugging statement")
}
```

To see the statement, you need to run with the `-v` flag.

```bash
$ go test -run TestLoggingDuringTest -v
# === RUN   TestLoggingDuringTest
# --- PASS: TestLoggingDuringTest (0.00s)
#         main_test.go:6: *** debugging statement
# PASS
# ok      github.com/elliotlarson/tryit   0.007s
```

To log from a method under test, just use `fmt.Print`.

## Skipping tests

Go allows you to skip tests with the `t.Skip` method:

```go

func TestSomeStuff(t *testing.T) {
  t.Skip("Skipping this test for now")
  // ...
}
```

Go also allows you to use the `-short` flag to your test run.  In your code you can setup conditional logic to use this flag:

```go
func TestSomeStuff(t *testing.T) {
  if testing.Short() {
    t.Skip("Skipping a long running method")
  }
  time.Sleep(10 * time.Second)
}
```

## Testing HTTP Response Handlers

You can use the `httptest` package to test request response handlers.

Here is the test code, testing the response code and the body:

```go
func TestStatusHandler(t *testing.T) {
	writer := httptest.NewRecorder()
	req, err := http.NewRequest("GET", "/status", nil)
	if err != nil {
		t.Error(err)
	}

	handler := http.HandlerFunc(StatusHandler)
	handler.ServeHTTP(writer, req)

	expectedResponseCode := 418
	if writer.Code != expectedResponseCode {
		t.Errorf("Expected response code %d, but got %d",
			expectedResponseCode,
			writer.Code)
	}

	expectedBody := "I'm a teapot\n"
	if writer.Body.String() != expectedBody {
		t.Errorf("Expected body to be \"%s\", but got: \"%s\"",
			expectedBody,
			writer.Body.String())
	}
```

Here is the handler code that passes this test:

```go
func StatusHandler(writer http.ResponseWriter, request *http.Request) {
	http.Error(writer, http.StatusText(http.StatusTeapot), http.StatusTeapot)
}

func main() {
	http.HandleFunc("/", StatusHandler)
	http.ListenAndServe(":8088", nil)
}
```

In our test we're using the `httptest` package's `NewRecorder` method to create an `io.Writer` that we can pass into our handler.  We also create a request to pass into the handler.  Then we execute the handler's `ServeHTTP` method and interrogate the writer/recorder to ensure that our handler behaved as expected.

## Testing template responses

You can test the output of a template by inspecting the response body with [goquery](github.com/PuerkitoBio/goquery).

Install `goquery`:

```bash
$ go get github.com/PuerkitoBio/goquery
```

Test response body:

```go
doc, err := goquery.NewDocumentFromReader(recorder.Body)
assert.Nil(t, err)

assert.Equal(t, 1, doc.Find("table#visits-table").Size())
assert.Equal(t, 2, doc.Find("table#visits-table tbody tr").Size())
assert.Contains(t, doc.Find("#visit-42 .user-name").Text(), "John Doe")
assert.Contains(t, doc.Find("#visit-42 .events").Text(), "20")
assert.Contains(
	t, doc.Find("#visit-42 .started-at").Text(), "08/09/2016 02:35PM",
)
```

