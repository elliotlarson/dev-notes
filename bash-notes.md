## Creating a script

Start the bash script with a "she-bang" that tells the system where to locate the bash interpreter:

```bash
#!/bin/bash
```

Create a file called `hello_world` and populate it with a simple `echo` command:

```bash
$ cat > hello_world
#!/bin/bash
echo "Hello, world!"
# ctrl-d
```

Then change the permissions on the file so everyone can execute it:

```bash
$ chmod a+x hello_world
```

Then you can execute the script with:

```bash
$./hello_world
# => Hello, world!
```

## Setting variables

To set a global variable (global to the script):

```bash
myvar="foo"
```

**Note**: There are no spaces around the `=` sign.

If the variable is meant not to change, it is conventional to to indicate that it is a constant with all caps:

```bash
MYVAR='foo'
```

If you are in the scope of a function, you can create a local variable like so:

```bash
myfunction() {
  local myvar="foo"
}
```

## Conditional statements with `if`

Say you have a variable `x` set to a number.  You can make a conditional branch of code on this like so:

```bash
x=5
if [ $x = 5 ]
then
  echo "x is 5"
elif [ $x = 6 ]
then
  echo "x is 6"
else
  echo "x is not 5 or 6"
fi
```

**Note**: There needs to be a space after the `[` and a space before `]`.

This could have been written in less lines like so:

```bash
x=5
if [ $x = 5 ]; then
  echo "x is 5"
elif [ $x = 6 ]; then
  echo "x is 6"
else
  echo "x is not 5 or 6"
fi
```

The `[]` is called the `test` command.  It can be written in two ways:

```bash
test $x = 5
```

```bash
[ $x = 5 ]
```

#### File specific tests

There are a number of file specific features you can use with test:

You can check if a file exists with `-e`:

```bash
if [ -e "$file" ]; then
  echo "file exists"
fi
```

Some of the usefule file test options:

| flag | test                                             |
|------|--------------------------------------------------|
| -e   | file exists                                      |
| -L   | file exists and is a symbolic link               |
| -r   | file exists and is readable                      |
| -w   | file exists and is writable                      |
| -x   | file exists and is executable                    |
| -s   | file exists and has a length greater than zero   |
| -d   | file is a directory                              |

You can also do tests on strings:

```bash
ANSWER=maybe
if [ "$ANSWER" = "maybe" ]; then
  echo "The answer is maybe!"
fi
```

Some useful string test options:

| test               | description                         |
|--------------------|-------------------------------------|
| string             | string is not null                  |
| -n string          | length of string is greater than 0  |
| -z string          | length of string is 0               |
| string1 = string2  | strings are equal                   |
| string1 == string2 | strings are equal                   |
| string1 > string2  | string1 is greater than string2     |
| string1 < string2  | string1 is less than string2        |
| string1 != string2 | string1 does not equal string2      |

One example of `-z` is checking if there is an argument being passed to the script:

```bash
if [ -z "$1" ]; then
  echo "no arguments"
else
  echo "argument passed in: $1"
fi
```

You can do integer based tests:

```bash
MY_NUM=23
if [ $MY_NUM -lt 42 ]; then
  echo "My number is less than 42"
fi
```

Some usefule integer comparisons:

| test                   | description                                   |
|------------------------|-----------------------------------------------|
| integer1 -eq integer2  | integer1 equals integer2                      |
| integer1 -lt integer2  | integer1 is less than integer2                |
| integer1 -gt integer2  | integer1 is greater than integer2             |
| integer1 -ge integer2  | integer1 is greater than or equal to integer2 |
| integer1 -le integer2  | integer1 is less than or equal to integer2    |
| integer1 -ne integer2  | integer1 is not equal to integer2             |

There is a newer test method `[[ test ]]` that adds a regular expression operator `=~` to string tests:

```bash
MY_STRING="(415) 555-5555"
if [[ "$MY_STRING" =~ ^\([0-9]{3}\)[[:space:]][0-9]{3}-[0-9]{4} ]]; then
  echo "It's a phone number"
fi
```

And, there is a test command, `(())` for performing arithmetic boolean operations:

```bash
if ((1)); then
  echo "It is true"
fi

INT=5
if ((INT == 4)); then
  echo "It's 5"
elif ((INT > 4)); then
  echo "It's greater than 4"
fi

if (( ((INT % 2)) == 0 )); then
  echo "It is even"
else
  echo "It is odd"
fi
```

You can use logical operators in tests:

| operation | test | [[]] and (()) |
|-----------|------|---------------|
| AND       | -a   | &&            |
| OR        | -o   | ||            |
| NOT       | !    | !             |

```bash
INT=50
if [[ $INT -ge 55 && $INT -lt 100 ]]; then
  echo "Woo hoo"
fi
```

This could also be written:

```bash
INT=50
if [[ $INT -ge 55 -a $INT -lt 100 ]]; then
  echo "Woo hoo"
fi
```

Here is a test that checks to see if the user is the root user:

```bash
if [[ $( id -u) -eq 0 ]]; then
  echo "The current user is root"
fi
```

## Exit statuses

Shell functions and scripts output a exit status number ranging from `0` to `255`.  `0` is a successful exit status, whereas all other numbers indicate a failure of some kind.

You can get the most recent exit status with the `?$` parameter, like so:

```bash
$ ls -l /my/dir
$ echo $?
# => 0
$ ls -l /dir/that/does/not/exist
# ls: /dir/that/does/not/exist: No such file or directory
$ echo $?
# => 1
```

You can manually return an exit code with the `exit` command:

```bash
exit 1
```

You can also use redirection to echo to standard error:

```bash
MY_NUM=0
if [ $MY_NUM -eq 0 ]; then
  echo "My number can not be zero" >&2
  exit 1
fi
```

## Reading value from standard input with `read`

You can read from standard input, or from a file if redirection is used.

```bash
echo "Please enter a number:"
read number
echo "Your number is $number."
```

Or, you can pass a flag like `-s` for silent mode, in case you don't want to print out secure information to the screen:

```bash
echo "Please enter your password"
echo -n "> "
read -s password
if [[ ${#password} -lt 8 ]]; then
  echo "The password is not long enough" >&2
  exit 1
else
  echo "Cool, that's a super secure password"
fi
```

Other `read` options:

| flag         | effect                                                  |
|--------------|---------------------------------------------------------|
| -a array     | assign input to an array                                |
| -e           | use readline to handle input                            |
| -n number    | read number of characters of input                      |
| -p prompt    | display a prompt for a user with the string prompt      |
| -t seconds   | timeout in seconds                                      |
| -d fd        | use input from file descriptor, rather than standard IO |

```bash
echo "What's your name"
read -e -t 5 -p "> " name
if [ $name ]; then
  echo "Hello, $name"
else
  echo "Sorry, not quick enough!" >&2
fi
```

You can also read multiple values in at once:

```bash
echo -n "Enter one or more values > "
read var1 var2 var3 var4 var5
echo "var1 = '$ var1'"
echo "var2 = '$ var2'"
echo "var3 = '$ var3'"
echo "var4 = '$ var4'"
echo "var5 = '$ var5'"
```

## Looping with `while`

You can print out the numbers 1 through 10, using a `while` loop, like so:

```bash
count=1
while [ $count -lt 11 ]; do
  echo $count
  count=$((count + 1))
done
```

In a while loop, you can use the standard `break` command to break out of the loop, and the `continue` command to skip to the next iteration of the loop.

#### Reading a file with `while`

Imagine that you have a file named `zipcodes.csv` containing this contents:

```csv
zipcode,plus4,city
94107,0203,SAN FRANCISCO
94106,0234,SAN FRANCISCO
95815,0423,SACRAMENTO
```

You can read this in like so:

```bash
count=1
while read line; do
  zipcode=$(echo $line | cut -d "," -f 1)
  plus4=$(echo $line | cut -d "," -f 2)
  city=$(echo $line | cut -d "," -f 3)
  echo -e "line #$count:\t$zipcode\t$plus4\t$city"
  count=$((count + 1))
done < zipcodes.csv
```

You can also pipe information in:

```bash
count=1
grep -i "San Francisco" zipcodes.csv | while read line; do
  zipcode=$(echo $line | cut -d "," -f 1)
  plus4=$(echo $line | cut -d "," -f 2)
  city=$(echo $line | cut -d "," -f 3)
  echo -e "line #$count:\t$zipcode\t$plus4\t$city"
  count=$((count + 1))
done
```

## Branching with the `case` statement

You can make multiple choice decisions with `case` like so:

```bash
echo "Choose a number between 1 and 3"
read -p "> " number

case $number in
  1)   echo "You chose 1"
       exit
       ;;
  2|3) echo "You chose 2 or 3"
       exit
       ;;
  *)   echo "Hey, I said a number between 1 and 3"
       exit
       ;;
esac
```

## Looping with `for`

You can iterate over a list of items with `for` like so:

```bash
for i in A B C D; do
  echo $i
done
```

You could also do this with brace expansion:

```bash
for i in {A..D}; do
  echo $i
done
```

Or, you could do this with globbing:

```bash
for i in *.pdf; do
  echo $i
done
```

You can also use `C` style expression loops:

```bash
for (( i=0; i < 5; i=i+1 )); do
  echo $i
done
```

## Handling signals with `trap`

If your script is long running, someone might `ctrl-c` to stop the process.  You can capture this `SIGINT` signal, like so:

```bash
capture_sigint() {
  echo 'capturing ctrl-c with trap'
  exit
}

trap capture_sigint SIGINT

while true; do
  printf '.'
  sleep 1
done
```

Now if you run this script it will continuously print out "." until you hit `ctrl-c`.  When you do, trap captures the `SIGINT` signal and passes it off to the `capture_sigint` function.

**Note**: You need to exit at the end of the function, otherwise script will continue to run.

#### Some interesting signals:

Signal    | Value | Action | Comment
----------|-------|--------|--------
SIGHUP    | 1     | term   | Hangup detected on controlling terminal or death of controlling process
SIGINT    | 2     | term   | Interrupt from keyboard
SIGQUIT   | 3     | core   | Quit from keyboard
SIGILL    | 4     | Core   | Illegal Instruction
SIGABRT   | 6     | Core   | Abort signal from abort(3)
SIGFPE    | 8     | Core   | Floating point exception
SIGKILL   | 9     | Term   | Kill signal
SIGSEGV   | 11    | Core   | Invalid memory reference
SIGPIPE   | 13    | Term   | Broken pipe: write to pipe with no readers
SIGALRM   | 14    | Term   | Timer signal from alarm(2)
SIGTERM   | 15    | Term   | Termination signal

**Note**: The signals SIGKILL and SIGSTOP cannot be caught, blocked, or ignored.

## Parameter expansions

Here is an example where we take the value of "foo" stored in a variable and append "_file" to it:

```bash
a="foo"
# echo '$a_file' will not work
echo '${a}_file'
```

#### Setting a default value for an expansion

You can set a default value for a variable in an expansion with the `${variable:-"default string"}` approach:

```bash
a="foo"
echo $a
# => "foo"

a=""
echo ${a:-"biz baz bar"}
# => "biz baz bar"
```

You can also do this with `${variable:="default string"}`.  However, if you use the `=` sign expansion, the variable will be set to the default value.

#### Requiring a variable to be set

You can use an expansion to verify that a variable is set, and exit with an error if not, like so:

```bash
echo ${a:?"error message about missing variable"}
# => "error message about missing variable"
echo $?
# => 1
```

#### Substitute value of a variable if set

You can also substitute a value of a variable in the event that it *is* set to something:

```bash
a="foo"
echo ${a:+"some other value"}
# => "some other value"
```

#### Getting the length of a string variable value

This will give you the number of characters:

```bash
a="Hello, world!"
echo ${#a}
# => 13
```

#### Pulling positional substrings out of a string

Lets say we have a quote from Mitch Hedberg:

```bash
quote="My fake plants died because I did not pretend to water them."
```

Grab all the characters from `n` to the end of the string:

```bash
echo ${quote:28}
# => I did not pretend to water them.
```

Grab characters from `n1` to `n2`, using `${varable:start_point:offset}`:

```bash
echo ${quote:3:16}
# => fake plants died
```

If you use a negative sign, you can start the grab from the end of the string (notice the space after the `:`):

```bash
echo ${quote: -22}
# => pretend to water them.

echo ${quote: -22:7}
# => pretend
```

#### Perform a search and replace for a pattern in a string

```bash
echo ${quote//\ /}
# => MyfakeplantsdiedbecauseIdidnotpretendtowaterthem.

echo ${quote//fake/real}
# => My real plants died because I did not pretend to water them.
```

#### Removing portions of a string value

Say we have a variable like this:

```bash
file=my_template.html.haml
```

To remove the shortest match of a pattern from the leading part of a string.  The pattern in this case is like a wildcard used in pathname expansions.

```bash
echo ${file#*.}
# => html.haml
```

To remove the longest match, use a `##`:

```bash
echo ${file##*.}
# => haml
```

To remove the shortest match from the end of a string:

```bash
echo ${file%.*}
# => my_template.html
```

To remove the longest match from the end of a string:

```bash
echo ${file%%.*}
# => my_template
```

## Arithmetic Operations

#### Converting from hex to decimal

```bash
echo $((0xff))
# => 255
```

#### Assignment operators

Notation            | Description
--------------------|-------------
parameter = value   | assigns value to parameter
parameter += value  | same as parameter = parameter + value
parameter -= value  | same as parameter = parameter - value
parameter *= value  | same as parameter = parameter * value
parameter /= value  | same as parameter = parameter / value
parameter %= value  | same as parameter = parameter % value
parameter++         | same as parameter = parameter + 1 (value incremented after return)
parameter--         | same as parameter = parameter - 1 (value incremented after return)
++parameter         | same as parameter = parameter + 1 (value incremented before return)
--parameter         | same as parameter = parameter - 1 (value incremented before return)

```bash
foo=1
echo $((foo++))
# => 1
echo $foo
# => 2

echo $((++foo))
# => 3
echo $foo
# => 3
```

## Colorizing output with `tput`

`tput` allows us to add some general styling characteristics to our terminal.  `tput` is a part of the `ncurses` package.

There are a number of text effects that you can use with `tput`:

argument      | effect
--------------|--------
bold          | Start bold text
smul          | Start underlined text
rmul          | End underlined text
rev           | Start reverse video
blink         | Start blinking text
invis         | Start invisible text
smso          | Start "standout" mode
rmso          | End "standout" mode
sgr0          | Turn off all attributes
setaf <value>	| Set foreground color
setab <value>	| Set background color

The colors that you can pass to foreground and background are:

number | color
-------|------
0	     | Black
1	     | Red
2	     | Green
3	     | Yellow
4	     | Blue
5	     | Magenta
6	     | Cyan
7	     | White
8	     | Not used
9	     | Reset to default color

To colorize text, I usually create a number of variables that hold the color and reset values.  Then I apply then to echo statement strings, like so:

```bash
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
COLOR_RESET=$(tput sgr0)

echo "${RED}Here is some red text.${COLOR_RESET}"
echo "${GREEN}Here is some red green.${COLOR_RESET}"
echo "${YELLOW}Here is some red yellow.${COLOR_RESET}"
```

## Creating a timestamp

```bash
$ date +'%Y%m%d%H%M%S'
```
