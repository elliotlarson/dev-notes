# Using the `sed` Stream Editor

Sed operates on each line of a file, processing it like a stream.  For each line, sed makes changes to the data as specified by the command.

Say we have a text file `data.txt` with the contents:

```text
The quick green fox jumps over the lazy green cat.
The quick green fox jumps over the lazy green cat.
The quick green fox jumps over the lazy green cat.
```

## Replace first occurance of word

To replace the first occurance of the word "green" with the word "brown" in each line, do this:

```bash
$ sed 's/green/brown/' data.txt
# => The quick brown fox jumps over the lazy green cat.
# => The quick brown fox jumps over the lazy green cat.
# => The quick brown fox jumps over the lazy green cat.
```

## Replace a specific occurance of a word

Lets replace the second occurance of the word "green" with the word "brown":

```bash
$ sed 's/green/brown/2' data.txt
# => The quick green fox jumps over the lazy brown cat.
# => The quick green fox jumps over the lazy brown cat.
# => The quick green fox jumps over the lazy brown cat.
```

## Replacing all occurences of a word

To replace all occurences of the word, use the `g` modifier:

```bash
$ sed 's/green/brown/g' data.txt
# => The quick brown fox jumps over the lazy brown cat.
# => The quick brown fox jumps over the lazy brown cat.
# => The quick brown fox jumps over the lazy brown cat.
```

## Multiple sed commands at once

You can issue multiple sed commands on one line by specifying the `-e` flag, and separate the commands with a `;`:

```bash
$ sed -e 's/green/brown/g' -e 's/cat/dog/' data.txt
# => The quick brown fox jumps over the lazy brown dog.
# => The quick brown fox jumps over the lazy brown dog.
# => The quick brown fox jumps over the lazy brown dog.
```

## Editing a specific line

You can choose to only edit a specified line:

```bash
$ sed '2s/green/brown/g' data.txt
# => The quick green fox jumps over the lazy green dog.
# => The quick brown fox jumps over the lazy brown dog.
# => The quick green fox jumps over the lazy green dog.
```

You can operate on more than one line at once:

```bash
$ sed '2,3s/green/brown/g' data.txt
# => The quick green fox jumps over the lazy green dog.
# => The quick brown fox jumps over the lazy brown dog.
# => The quick brown fox jumps over the lazy brown dog.
```

You can operate on the last line (the end of file).  Note: If you sed two files at the same time, this will operate on the last line of the last file only.

```bash
$ sed '$s/green/brown/g' data.txt
# => The quick green fox jumps over the lazy green cat.
# => The quick green fox jumps over the lazy green cat.
# => The quick brown fox jumps over the lazy brown cat.
```

You can also choose to operate on all lines that do not match the address:

```bash
sed '!2,3/green/brown/g' data.txt
# => The quick green fox jumps over the lazy green cat.
# => The quick green fox jumps over the lazy green cat.
# => The quick brown fox jumps over the lazy brown cat.
```

## Replacing a word on lines that match a pattern

You can apply sed commands only to lines that match a pattern:

```bash
$ grep root /etc/passwd
# => root:*:0:0:System Administrator:/var/root:/bin/sh
$ sed '/root/s/Administrator/czar/' /etc/passwd
# => root:*:0:0:System czar:/var/root:/bin/sh
```

## Delete specified lines

Lets say you have a header line you want to get rid of:

```text
zipcode,plus4,state_id,county_id,district_id,region_id
93020,7000,5,105,196,713
93020,7001,5,105,196,713
...
```

You can pull out the header, with:

```bash
$ head -n 3 zipcodes.csv | sed '1d'
# => 93020,7000,5,105,196,713
# => 93020,7001,5,105,196,713
```

## Use the matched pattern in a replacement

To use the matched pattern in a replacement, you can use the `&` character:

```bash
$ echo "foo foo foo" | sed 's/foo/<i>&<\/i>/g'
# => <i>foo</i> <i>foo</i> <i>foo</i>
```

You can also use `\n` to put matched patter groups in escaped parens `\(\)`:

```bash
$ echo "foo bar baz" | sed 's/\(fo*\) \(ba[rz]\) \(ba[rz]\)/<<\3>> <<\2>> <<\1>>/g'
# => <<baz>> <<bar>> <<foo>>
```

## Printing only specified addresses

You can tell `sed` to supress printing with the `-n` flag, and then use the `p` modifier to print only the lines you want:

```bash
$ sed -n 1p data.txt
# => The quick green fox jumps over the lazy green cat.
```

You can also print out a range of lines with:

```bash
# Printing lines 100 to 200
$ sed -n '100,200p' myfile.log
```

Do do a replacement on the specified line and then print it, use the `p` modifier after the `s` command:

```bash
$ sed -n '1s/green/brown/p' quick-green-fox.txt
# => The quick brown fox jumps over the lazy green cat.
```

You can also choose to print the line from one regex to the next:

Say you have a file called `dukeofyork.txt` containing this:

```text
The grand old Duke of York
He had ten thousand men
He marched them up to the top of the hill
And he marched them down again
And when they were up they were up
And when they were down they were down
And when they were only half-way up
They were neither up nor down
```

You can grab the line from the first occurance of "marched" to the next line that contains "when" with:

```bash
$ sed -n '/marched/,/when/p' dukeofyork.txt
# => He marched them up to the top of the hill
# => And he marched them down again
# => And when they were up they were up
```

## Loading `sed` commands from a file

You can add your commands to a file like so:

```bash
$ cat > sed-script
s/green/brown/g
s/cat/dog/g
s/fox/hedgehog/g
# ctrl-d
$ sed -f sed-script quick-green-fox.txt
# => The quick brown hedgehog jumps over the lazy brown dog.
# => The quick brown hedgehog jumps over the lazy brown dog.
# => The quick brown hedgehog jumps over the lazy brown dog.
```

## Reading in a file at address points

You can use sed to print out the contents of a file after a match is made.

Say you have a file with a line of text:

```bash
$ cat > foofoofoo.txt
=> Foo Foo Foo
# ctrl-d
```

## Installing `gnu-sed` on mac

The `sed` on the mac is different.  To use the standard GNU `sed`:

```bash
$ brew install gnu-sed
$ export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
```
