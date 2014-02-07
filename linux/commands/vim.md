# Vim Notes

## Resources

* power line font: https://github.com/eugeneching/consolas-powerline-vim

## Commands

#### Finding and replacing across multiple files

http://www.isaacsloan.com/posts/3-vim-find-replace-in-projects-using-ack

	:args `ack -l keywords`
	:argdo %s/keywords/replacement/ge | update
	
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

	gi

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