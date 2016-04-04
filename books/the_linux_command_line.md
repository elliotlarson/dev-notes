## Redirection

#### Redirect standard out to a file

```bash
$ ls -l /my/dir > my_file.txt
```

#### Redirecting standard error to a file

```bash
$ ls -l /my/missing/dir 2> my_error_file.txt
```

#### Redirecting both standard out and standard error to files

```bash
$ ls -l /my/dir > my_file.txt 2> my_error_file.txt
```

#### Redirect standard out and error to `/dev/null`

This basically says: "Redirect standard out to /dev/null. Oh, and redirect standard error to the place where standard out is going.

```bash
$ wibble > /dev/null 2>&1
```

There is a more modern shortcut for this:

```bash
$ wibble &> /dev/null
```

## Redirect standard out to a file and pass it along with `tee`

This takes the output of the ls command, saves it to `ls.txt`, and passes it along as standard out to the piped grep command.

```bash
$ ls /usr/ bin | tee ls.txt | grep zip
```

If you want to append to the file rather than overwrite it, you need the `-a` flag:

```bash
$ ls /usr/ bin | tee -a ls.txt | grep zip
```

## List files in order of last modified with `ls`

Using the `ls` command with the `-t` flag will show the results in the order that they were last modified:

```bash
$ ls -lt
```

You can also reverse this list by using the `--reverse` option, or `-r` for short.

## List files in order of size with `ls`

Using the `-S` flag you can view files in order of file size:

```bash
$ ls -S
```

## Generate a quick file with `cat`

```bash
$ cat > my_new_file.txt
foo foo foo bar foo bar foo
# ctrl + d
```

## Print out file contents with line numbers with `cat` 

Lets say we have this content in the file `brown-fox.txt`:

<pre>
The quick brown fox

jumped over the lazy dog.



</pre>

You can `cat` the output with line numbers using the `-n` flag:

```bash
$ cat -n brown-fox.txt

     1	the quick brown fox
     2
     3	jumped over the lazy dog.
     4
     5
     6
     7
     8
```

If you want to strip out some of the additional blank lines, you can use the `-s` flag:

```bash
$ cat -ns brown-fox.txt
     1	the quick brown fox
     2
     3	jumped over the lazy dog.
     4
```

## Sorting a file by a field with `sort` 

The `sort` command allows you to sort by a different field using the `-k` flag:

```bash
$ ls -l /usr/bin | sort -rn -k 5 | head
-rwxr-xr-x   1 root   wheel  10577792 Sep  6 20:22 php
-r-xr-xr-x   1 root   wheel   9548192 Aug  4  2015 emacs
-r-xr-xr-x   1 root   wheel   5661904 Sep  9  2014 parl5.18
-r-xr-xr-x   1 root   wheel   5493504 Sep  9  2014 parl5.16
-rwxr-xr-x   1 root   wheel   3205456 Mar 23  2015 emacs-undumped
-r-xr-xr-x   1 root   wheel   2243568 Sep  9  2014 db_printlog
-r-xr-xr-x   1 root   wheel   2196784 Sep  9  2014 db_codegen
-r-xr-xr-x   1 root   wheel   2189152 Sep  9  2014 db_load
-r-xr-xr-x   1 root   wheel   2180592 Sep  9  2014 db_hotbackup
-r-xr-xr-x   1 root   wheel   2172336 Sep  9  2014 db_recover
```

The `-r` flag sorts in reverse, and the `-n` flag sorts numerically.  The `-k 5` here tells the command to sort by column 5, which is the file size part of the directory listing.  So, this shows the 10 largest files in `/usr/bin`.

## Sorting by more than one field with `sort` 

Lets say we have a list like this in a file called `distros.txt`:

```bash
SUSE	10.2	12/07/2006
Fedora	10	11/25/2008
SUSE	11.0	06/19/2008
Ubuntu	8.04	04/24/2008
Fedora	8	11/08/2007
SUSE	10.3	10/04/2007
Ubuntu	6.10	10/26/2006
Fedora	7	05/31/2007
Ubuntu	7.10	10/18/2007
Ubuntu	7.04	04/19/2007
SUSE	10.1	05/11/2006
Fedora	6	10/24/2006
Fedora	9	05/13/2008
Ubuntu	6.06	06/01/2006
Ubuntu	8.10	10/30/2008
Fedora	5	03/20/2006
```

We can sort by the first and second columns with `sort` like this:

```bash
$ cat distros.txt | sort -k 1,1 -k 2n
Fedora	5	03/20/2006
Fedora	6	10/24/2006
Fedora	7	05/31/2007
Fedora	8	11/08/2007
Fedora	9	05/13/2008
Fedora	10	11/25/2008
SUSE	10.1	05/11/2006
SUSE	10.2	12/07/2006
SUSE	10.3	10/04/2007
SUSE	11.0	06/19/2008
Ubuntu	6.06	06/01/2006
Ubuntu	6.10	10/26/2006
Ubuntu	7.04	04/19/2007
Ubuntu	7.10	10/18/2007
Ubuntu	8.04	04/24/2008
Ubuntu	8.10	10/30/2008
``` 

The `-k 1,1` tells sort to sort starting at column 1 and ending at column 1.  Then the `-k 2n` says to sort by column 2 using the numeric sort.

## Sort by a piece of a column with `sort` 

You can identify the character starting point of a column with a decimal notation.

Say you have this data in a file `data.txt` 

<pre>
01 Joe Sr.Designer
02 Marie Jr.Developer
03 Albert Jr.Designer
04 Dave Sr.Developer
</pre>

You can sort starting with the 3rd character of the 3rd column like so:

```bash
$ sort -k 3.3 data.txt
01 Joe Sr.Designer
03 Albert Jr.Designer
02 Marie Jr.Developer
04 Dave Sr.Developer
```

You can also tell sort where to stop doing the comparison:

```bash
$ sort -k 3.3,3.5 data.txt
```

This will start sorting with the 3rd character of the 3rd column, and stop comparing with the 5th character of the 3rd column (so, it will just look at "De" in each case).

## Sorting by a specific delimiter with `sort` 

Sort uses tabs as the default delimiter.  To change this you need the `-t 'delimiter'` flag:

```bash
$ tail /etc/passwd | sort -k 5 -t ':'
```

## Removing or showing duplicates with `uniq`

To show only unique entries (you need to sort first for this to work):

```bash
$ cat /usr/bin /usr/local/bin | sort | uniq
```

To show only the duplicate entries, pass the `-d` flag:

```bash
$ cat /usr/bin /usr/local/bin | sort | uniq -d
```

## Count the number of lines with `wc`

To count lines, you need to use the `-l` flag for the word count `wc` command:

```bash
$ cat my_file.txt | wc -l
```

## Search for a term ignoring case with `grep`

You need to use the `-i` flag:

```bash
$ ls -l /var/log | grep -i auth
```

## Search for a pattern and only return the match with `grep`

You need the `-o` flag:

```bash
$ grep -oE "[[:digit:]]*.[[:digit:]]*.[[:digit:]]*"
```

## Search for only lines that don't match with `grep`

You need the `-v` flag:

```bash
cat my_code_file.rb | grep -v "^\s*#.*"
```

## Keyboard shortcuts for `readline`

* `ctrl - d` = delete the character at the cursor location
* `ctrl - k` = kill text from the cursor location to the end of line
* `ctrl - u` = kill text from the cursor location to the beginning of the line


## Re-execute a series of commands with `ctrl-o`

Say you've executed:

```bash
$ echo "hello"
$ echo "world"
$ echo "happy days"
```

Now you want to re-execute these three commands.  Use `ctrl-p` to navigate back to the `echo "world"` command, and then execute it with `ctrl-o`.  It will execute the `echo "hello"` and then put the next command `echo "world"` on the command line.  So, you can keep pressing `ctrl-o` to quickly cycle throught a series of commands.

## Execute an item from `history`

View the history IDs with something like:

```bash
$ history
# 10060  echo "hello"
# 10061  echo "world"
# 10062  echo "happy days"
```

Re-run `echo "hello"` with this:

```bash
$ !10060
```

## Octal permissions used for `chmod`

| Octal | File mode |
|-------|-----------|
| 0     | ---       |
| 1     | --x       |
| 2     | -w-       |
| 3     | -wx       |
| 4     | r--       |
| 5     | r-x       |
| 6     | rw-       |
| 7     | rwx       |

## Symbolic permissions for `chmod`

| Symbol | Meaning      |
|--------|--------------|
| u      | user         |
| g      | group        |
| o      | others       |
| a      | all          |

## Change owner and group for directory contents with `chown`

This will reset the owner to `admin` and the group to `deploy` recursively for all files and directories in the foo directory:

```bash
$ chown -R admin:deploy foo
```

## Print out the users on the system with `awk`

The entries in `/etc/passwd` have a lot of additional information in them.  Each line looks like: `statd:x:105:65534::/var/lib/nfs:/bin/false`.  To grab just the username, we need to split the values with the `:` delimiter and grab the first value.

```bash
$ awk -F ':' '{print $1}' /etc/passwd
```

You could also use `cut` for this:

```bash
$ cut -d : -f1 /etc/passwd
```

You can also use this approach to get the group names on the system:

```bash
$ awk -F ':' '{print $1}' /etc/group
```

## Showing lines around `grep` search result

To show lines before the search result with the `-B` flag:

```bash
$ grep -B 5 foo bar.txt
```

Showing lines after the search result with the `-A` flag:

```bash
$ grep -C 5 foo bar.txt
```

Showing lines before and after the result with the `-C` flag:

```bash
$ grep -C 5 foo bar.txt
```

## Use `find` to get a list of directories

Here we're getting directories in our home directory.

```bash
$ find ~/ -type d
```

We can also just get the files with:

```bash
$ find ~/ -type f
```

## Use `find` to get JPG files larger than a megabyte

```bash
$ find ~/ -name "*.JPG" -size +1M
```

## Use `find` to get files modified a day or more ago

```bash
$ find ~/ -mtime +1
```

You can use this with the delete flag to remove files older than 1 day:

```bash
$ find ~/ -mtime +1 -delete
```

## Syncing a directory into another with `rsync`

Using the `-a` flag adds recursive synching, archiving, and preserves file permissions and ownership.

```bash
$ rsync -a dir1/ dir2
```

The trailing slash `/` after `dir1` makes it so that it syncs the contents of `dir1` into `dir2`.  Without the slash, `dir1` would be synced into `dir2` such that `dir2` would contain `dir1`.

To do a dry-run, you can pass in the `-n` and `-v` flags.

```bash
$ rsync -avn dir1/ dir2
```

## Syncing a local directory to a remote directory with `rsync`

```bash
$ rsync -a ~/dir1 username@remote_host:destination_directory
```

## Syncing a remote directory to a local directory with `rsync`

```bash
$ rsync -a username@remote_host:/home/username/dir1 place_to_sync_on_local_machine
```

## The difference between `grep` regular expression types

There are two types of regular expressions for `grep`:

* **POSIX Basic (BRE):** With BRE, the following meta characters are recognized: `^ $ . [ ] *`, and all other characters are considered literals.  However, if the meta characters `( ) { } +` are escaped with a backslash, they are usable.
* **Extended (ERE):** With ERE, the following meta characters are added `( ) { } ? + |`.  To use extended regular expressions, you need the `-E` flag.
  `$ grep -E 'AAA|BBB'` 

## BRE and ERE regular expressions matchers

character | function | example
----------|----------|--------- 
^ | match begining of line | `grep '^#' myfile.txt` 
$ | match end of line | `grep 'foo$' myfile.txt` 
[] | match characters between brackets | `grep '[fb]' myfile.txt` 
[^] | match characters **not** between brackets | `grep '[^zx]' myfile.txt` 
[-] | match range of characters between brackets | `grep '[A-Z]' myfile.txt` 
[:alnum:] | alphanumeric characters, same as [A-Za-z0-9] | `grep '[[:alnum:]]' myfile.txt` 
[:word:] | same as `alnum` with `_` character | `grep '[[:word:]]' myfile.txt` 
[:alpha:] | same as [A-Za-z] | `grep '[[:alpha:]]' myfile.txt`
[:blank:] | includes space and tab characters | `grep '[[:blank:]]' myfile.txt` 
[:digit:] | same as [0-9] | `grep '[[:digit:]]' myfile.txt` 
[:lower:] | lower case letter | `grep '[[:lower:]]' myfile.txt` 
[:upper:] | upper case letter | `grep '[[:upper:]]' myfile.txt` 
[:punct:] | punctuation marks | `grep '[[:punct:]]' myfile.txt` 
[:space:] | same as [\t\r\n\v\f] | `grep '[[:space:]]' myfile.txt`
&#124; | match one or the other | `grep -E 'foo`&#124;`bar'` 
? | match zero or 1 time | `grep -E 'z?' myfile.txt` 
* | match zero or more times | `grep -E 'z*' myfile.txt`
+ | match one or more times | `grep -E 'z+' myfile.txt` 
{n} | match a character `n` times | `grep -E 'z{3}' myfile.txt` 
{n,m} | match `n` times but no more than `m` times | `grep -E 'z{3,5}' myfile.txt` 
{n,} | match `n` or more times | `grep -E 'z{3,}' myfile.txt` 
{,m} | match no more than `m` times | `grep -E 'z{,3}' myfile.txt` 
