# Tmux Notes

## getting fonts to install

I installed this font to get tmux to work: https://github.com/eugeneching/consolas-powerline-vim

then I installed this font to get vim to work: https://github.com/runsisi/consolas-font-for-powerline

## Resources

* https://github.com/aziz/tmuxinator
* http://robots.thoughtbot.com/post/55273519322/running-specs-from-vim-sent-to-tmux-via-tslime

## From Tmux session

#### detach a session

	ctrl + a > d

#### rename a session

	ctrl + a > $

#### show key bindings

	ctrl + a > ?

#### show open sessions from within tmux session

	ctrl + a > s

#### swap panes to the left

	ctrl + a > {

#### clear the screen

	ctrl + l
	
#### rename window

	ctrl + a > ,
	
#### kill a pane

	ctrl + a > x
	
#### show pane numbers

	ctrl + a > q
	
#### select a pane number

## From Command Line

#### create a new session

	$ tmux new -s sessionname
	
#### list all sessions

	$ tmux ls
	
#### kill a session 

	$ tmux kill-session -t sessionname
	
#### attach to session

	$ tmux attach -t sessionname
	
