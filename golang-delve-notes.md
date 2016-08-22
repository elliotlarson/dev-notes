# Debugging with Delve

[Delve](https://github.com/derekparker/delve) (dlv) is a full featured, community developed Go debugger.

## Installation

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

## Usage

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

If you are debugging an application that doesn't take in command line arguments the command, to start a debugging session is:

```bash
$ sudo dlv debug
```

In our case, we *do* want command line arguments, so we append `-- arg1 arg2 arg2`.

Once the debugging session is started, we set breakpoints.  We did this with `b main.go:18`.  This tells dlv to set a breakpoint at line 18 in the `main.go` file.  

Once we're done setting breakpoints, we tell dlv to execute throught to the first breakpoint with the continue command `c`.

When dlv hits a breakpoint, it prints out the code's context and allows you to poke around.  To look at variables, use the print command.  In our case, we looked at the args being passed in with `p os.Args`.

Once you're finished with your debugging session, you can `ctrl-d` to quit.

## Debugging tests with Delve

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

#### Dealing with `GOPATH` sudo issues

I had problems executing the `dlv` test with sudo when having to import packages.  This solved the problem.

```bash
$ sudo /usr/bin/env GOPATH=/Users/Elliot/Work/GoCode dlv test ./models
```

