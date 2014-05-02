# Golang Notes

## Intro Misc

#### Getting version of Go on your system

    $ go version

 
#### Telling Go where to download packages with `go get`

Add this to your bash profile

    export GOPATH="$HOME/gocode";
    
Make sure this directory exists:

    $ mkdir ~/gocode
    
Then you can execute a command like so:

    $ go get github.com/hoisie/web
    
    
#### Running a Go Program

    $ go run hello.go
    
#### Getting documentation on a method

    $ godoc fmt Println
    
or get the documentation for the whole package:

    $ godoc fmt
    
#### Developing Go with Vim

* [vim-go](https://github.com/fatih/vim-go)

* [article about vim-go](http://blog.gopheracademy.com/vimgo-development-environment)

## Using GDC for debugging

1. follow some of [these instructions for creating a signed certificate for the codesign](http://www.opensource.apple.com/source/lldb/lldb-69/docs/code-signing.txt)
2. install gdc: `$ brew install homebrew/dupes/gdb`
3. apply the codesign to gdc: `$ codesign -s gdb_codesign /usr/local/bin/gdb`
4. build your program: `$ go build main.go`
5. set a brake point: `l` to list the code, `b 75` to set a brake point at line 75, then `r` to run to the breakpoint