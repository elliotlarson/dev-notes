# Ruby Process Notes

## Get number of cores on machine

```ruby
require "etc"
cores = Etc.nprocessors
```

## Current program's process ID

All programs, including the current Ruby program, have a process id.

Print it out with:

```ruby
puts Process.pid
# or
puts $$
```

The process also has a parent process ID:

```ruby
puts Process.ppid
```

With this information you can use the OS commands to view the process:

```bash
ps -p 87435
#=>  PID TTY           TIME CMD
#=> 87838 ttys000    0:00.41 pry
```

## Process name

You can also get and set the current process's name

```ruby
puts $PROGRAM_NAME
# => pry
$PROGRAM_NAME = 'foo foo foo'
```

```bash
ps -p 87435
#=>  PID TTY           TIME CMD
#=> 87838 ttys000    0:00.41 foo foo foo
```

## Files have a file descriptor

In Unix, files, pipes, and sockets are all considered files and they have descriptors

```ruby
passwd_file = File.open('/etc/password')
puts passwd_file.fileno
#=> 10
```

When you close the file, the file descriptor number is released to the OS

```ruby
passwd_file.close #=> releases file descriptor 10
```

Ruby has access to the standard streams:

```ruby
puts STDIN.fileno
#=> 0
puts STDOUT.fileno
#=> 1
puts STDERR.fileno
#=> 2
```

## Environment variables are hash-like

`ENV` in Ruby implements `Enumerable` and some of `Hash`, but it isn't a hash.

```ruby
puts ENV['SHELL']
#=> /bin/zsh
puts ENV.has_key?('PATH')
#=> true
puts ENV.is_a?(Hash)
#=> false
```

## Process arguments

Every process has access to an `ARGV` array (stands for "argument vector"), which contains arguments passed to the program

Say you have a simple ruby program `print_args.rb`:

```ruby
#!/usr/bin/env ruby
puts ARGV
```

```bash
$ ruby print_args.rb foo bar -a baz
#=> ["foo", "bar", "-a", "baz"]
```

It's just an array, which you can manipulate and modify as an array.  For example:

```ruby
puts ARGV.include?('-a')
#=> true
puts ARGV.include?('-a') && ARGV[ARGV.index('-a') + 1]
#=> baz
```

## Process exit codes

Unix processes have exit codes from 0-255.  Exit code 0 = success.  All other codes are error cases.  Exit code 1 = generic error case.

You can exit from a ruby command with

```ruby
exit # defaults to 0, or success
exit 1 # error case
```

You can perform actions on exit

```ruby
at_exit { puts 'doing some exit stuff' }
exit
#=> doing some exit stuff
```

You can also force Ruby to exit immediately without calling `at_exit` with `exit!`

```ruby
at_exit { puts 'doing some exit stuff' }
exit!
#=>
```

With `abort` you can exit with code `1` and optionally pass a message to STDERR:

```ruby
abort
```

```ruby
abort 'with a message'
#=> with a message [on stderr]
```

You can also `raise` an exception, which sets exit code to `1`, sends a message to STDERR and outputs a backtrace

```ruby
raise :hell
#=> raise.rb:2:in `raise': exception class/object expected (TypeError)
#=>     from raise.rb:2:in `<main>'
```

## Forking

A process can fork off a new child process.  The process is a copy of the parent process, except:

* The new process has it's own process ID
* The new process has a different parent process ID (the process that just forked it)
* The child process has it's own copy of the parent's file descriptors

Forking utilizes copy-on-write, which means the child process uses all of the same data as the parent, until the data needs to be modified.  So, in Ruby, if you create an array in a script and then fork, the sub process will get the same array.  But, if you modify the array in any way, the array is copied and becomes distinct from the array in the parent process.

`fork` utilizes the Unix system call `fork(2)` under the hood.  This is not available on Windows.

View documentation page for `fork(2)` with:

```bash
$ man 2 fork
```

The `fork` method executes its code in a child process.  And it returns the process ID of the child.

```ruby
child_pid = fork do
  # code executed in child process
end
```

Parent processes can exit before child processes.  Notice how the child process in the following prints out after the parent exists:

```ruby
fork do
  puts 'I am an orphan'
end
puts 'Parent process died...'
#=> Parent process died...
#=> I am an orphan
```

You can keep the parent process alive until the child process exits with `Process.wait`.

```ruby
fork do
  sleep 3
  puts 'Orphan exiting'
end
Process.wait
puts 'Parent process exiting'
#=> Orphan exiting
#=> Parent process exiting
```

You can also tell `wait` to wait for a specified process ID

```ruby
favorite_child_id = fork do
  sleep 1
  puts 'Favorite child exit'
end
second_favorite_child_id = fork do
  sleep 2
  puts 'Second favorite child exit'
end
Process.wait(favorite_child_id)
puts 'Parent exit'
#=> Favorite child exit
#=> Parent exit
#=> Second favorite child exit
```

You can also get the status of the exiting sub-process with `wait2`:

```ruby
3.times do
  fork do
    exit(rand(10) % 2 == 0 ? 2 : 1)
  end
end
3.times do
  pid, status = Process.wait2
  puts "Child pid #{pid} exited with status #{status}"
end
#=> Child pid 28253 exited with status pid 28253 exit 2
#=> Child pid 28252 exited with status pid 28252 exit 2
#=> Child pid 28251 exited with status pid 28251 exit 1
```

Zombies are child processes that have exited but the OS is saving information about their status.

When you wait for a process, the process is not a zombie.  If you don't want to wait, but you want to "fire and forget", you can call `detach`:

```ruby
pid = fork do
  puts 'Child exited'
end
Process.detach(pid)
puts 'Parent exited'
```

The `ppid` of an orphaned process is 1, the master system process `init`.

### Fork and exec

The combination of these two is at the heart of process spawning in Unix.  You use fork to create a copy of the current process and then exec to transform it.

### Sharing information between child and parent processes

When you fork, file descriptors are shared with the child process. If you want to communicate between the processes you can create a `pipe`, which has it's own file descriptors for readers and writers.

```ruby
require('open3')

reader, writer = IO.pipe

pid = Kernel.fork do
  reader.close
  std_err_and_out, status = Open3.capture2e('ls', '-l')
  writer.puts std_err_and_out
end

writer.close
puts reader.read
Process.wait(pid)
```

Since the reader and writers are copied into the subprocess, we close the reader in the forked process.  We're not going to use it.  We also close the writer in the parent process since we're not going to use it.

## Comparing the different approaches to creating a sub process

There are a myriad of options when it comes to creating sub processes in Ruby.  They all do things slightly differently, but they all use some form of system `fork` and `exec` under the hood.

### Back ticks

```ruby
ls_out = `ls -l`
```

Captures and returns stdout so it can be assigned to a variable.

This doesn't work with array syntax, so it's a security risk and best used for quick and dirty system calls)

### Exec

This replaces the current process with the subprocess.

```ruby
Kernel.exec('ls', '-l')
puts('after exec')
```

The "after exec" statement never gets sent to stdout because calling exec replaces the parent process before the puts statement can do it's thing.

### Spawn

Executes a command in a sub-shell but doesn't wait for it to return.

It returns the process id.

```ruby
# this is blocking
pid = Process.spawn('tar xf ruby-2.0.0-p195.tar.bz2')
Process.wait(pid)

# this is non-blocking
pid = Process.spawn('tar xf ruby-2.0.0-p195.tar.bz2')
Process.detach(pid)
```

If you don't either `wait` or `detach` you run the risk of creating zombie processes, which can eat up system resources.

You can also pass in a hash of environment variables:

```ruby
pid = Process.spawn({ 'FOO' => 'bar' }, 'some-cmd-that-requires-foo')
Process.detach(pid)
```

#### Difference between spawn and fork

Use `Process.spawn` if you want to execute another application in a subprocess.  Use `fork` and `exec` if you want to execute arbitrary Ruby code in a sub process.
Get the output of the command:

```ruby
r, w = IO.pipe
pid = spawn(command, out: w)   # r, w is closed in the child process.
w.close
```

### System

Executes a command in a sub-shell but waits for it to execute.  Like a blocking version of `Process.spawn`:

```ruby
Kernel.system({ 'BUNDLER_EDITOR' => 'vim' }, 'bundle', 'open', 'devise')
```

System also prints out the status of the subprocess, true for success and false for any error code exit.

```ruby
status = Kernel.system('which', 'ruby') # status = true
#=> /Users/Elliot/.rbenv/versions/2.4.2/bin/ruby
status = Kernel.system('which', 'foo') # status = false
```

### Popen

`IO.popen` runs the specified command as a subprocess and the subprocesses standard input and output will be connected to the IO object.

```ruby
io_obj = IO.popen(['ls', '-l'])
puts io_obj.read
```

Note that the File descriptor is a stream IO object.  When you read, you flush the buffer (is that the correct terminology?) and the content is gone.

You can also do it in one step and achieve something similar to backticks:

```ruby
header_str = IO.popen(['head', '-n', '1', 'my_data.csv']).read
```

Note that this is better than backticks because the array approach you pass to `IO.popen` is escaped, which is more secure than the string you pass to backticks.

This also leaves the file handle open, so this might be better:

```ruby
header_str = IO.popen(['head', '-n', '1', 'my_data.csv']) { |fh| fh.read }
```

or

```ruby
header_str = IO.popen(['head', '-n', '1', 'my_data.csv'], &:read)
```
