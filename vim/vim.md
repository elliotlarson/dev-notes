# Vim Notes

## Resources

* power line font: https://github.com/eugeneching/consolas-powerline-vim

## Overriding vim solarized 

look for this

```
elseif g:solarized_termcolors == 256
```

set this:

```
let s:base03      = "233"
let s:base02      = "233"
let s:base01      = "236"
let s:base00      = "234"
```

## Misc Notes

#### Paste contents of the yank register into search bar

1. yank some text
2. in the search bar enter `ctrl + r` then `"`

#### Create a Directory for the current file

I'm often creating a spec file on the fly by using my Gary Bernhardt test/implementation file switcher.  I switch from the my new implementation file to a new test file, which doesn't exist yet.  The test file switcher will create the file in the buffer.  But when I try to save it, if it's located in a directory that doesn't exist in my spec directory, it errors out with a directory not found error.  

But, I can auto create the directory with this workflow:

In the spec file:

```
:!mkdir 
```

... then press **ctrl** + **r** and then **%**.  This will place the file name and path on the command.  Then delete the filename and hit **enter**.

#### Rails extract partial

In a view file extract a section to a partial.

Select the text. Go into command mode and type:

    :Rextract my_partial.html.haml

#### Copying a line to another line

"T" is the shorthand for copy (i.e. move to)

Copy 21 to current line

    :21t.
    
Copy 21 to line 35

    :21t35

#### Moving a line to another line

Move 21 to current line

    :21m.
    
Move 21 to line 35

    :21m35

#### Finding and replacing across multiple files

http://www.isaacsloan.com/posts/3-vim-find-replace-in-projects-using-ack

	:args `ack -l keywords`
	:argdo %s/keywords/replacement/gce | update
	
another approach: http://www.isaacsloan.com/posts/51-vim-find-and-replace-in-project-episode-2

####  omni completion

	c-x c-l

#### Insert yanked register

	insert mode 
	<c-r>0

#### Do calculation and insert results

	insert mode
	<c-r>=

#### surround word with "

	ysiw"

#### add to first number in line

	<c-a>

#### subtract from first number in line

	<c-x>

#### go to the place where you were last in insert mode

This enters insert mode at that point

	gi
	
#### go to line where you were last in insert mode

This does not enter insert mode

    `.

#### looks for method under cursor using ctags

	<c-]>

#### start recording a macro named s
	
	qs

#### stop recording macro

	q 

#### apply a macro named s

	@s

#### apply a macro named s to lines 5-10

	:5,10norm! @s

#### find the current file in nerd tree

	:NERDTreeFind

#### close all windows but the current window

	:only

#### set relative line numbering

	:set rnu

#### set regular line numbering

	:set nu

#### navigate to the previous and next buffer

	[b and ]b

#### create tags file for app

http://blog.bojica.com/2010/06/27/ctags-and-vim-for-ruby-on-rails-development

	ctags -R --exclude=.git --exclude=log --exclude=tmp *


## PLUGIN IDEAS

Create a vim script or plugin to toggle the presence of ", focus: true" on the nearest contest or describe block

## ARCHIVE

Commands I've already learned

#### visually select a region and indent it according to current syntax rules

	V=

#### indent current line according to current syntax rules

	==

#### select just the word

	iw

#### select word and white space at end

	aw 

#### select up to character but not including

	t{char} 

#### change surrounding " to '
	
	cs"' 

#### exit vim to the terminal

	<ctrl>z

#### get back to vim after exiting to the terminal

	fg

#### move to next tab

	gt

#### move to previous tab

	gT	

#### move to tab number #

	#gt	