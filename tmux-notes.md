# Tmux Notes

## Resources

* https://github.com/aziz/tmuxinator
* http://robots.thoughtbot.com/post/55273519322/running-specs-from-vim-sent-to-tmux-via-tslime

## From Tmux session

#### Swap window

Enter command mode

```text
ctrl + a > :
```

To swap window 1 with window 2:

```bash
: swap-window -s 1 -t 2
```

#### Detach a session

```text
ctrl + a > d
```

#### Rename a session

```text
ctrl + a > $
```

#### Show key bindings

```text
ctrl + a > ?
```

#### Show open sessions from within tmux session

```text
ctrl + a > s
```

#### Swap panes to the left

```text
ctrl + a > {
```

#### Clear the screen

```text
ctrl + l
```
	
#### Rename window

```text
ctrl + a > ,
```
	
#### Kill a pane

```text
ctrl + a > x
```
	
#### Show pane numbers

```text
ctrl + a > q
```
	
#### Select a pane number

## From Command Line

#### Create a new session

```bash
$ tmux new -s sessionname
```
	
#### List all sessions

```bash
$ tmux ls
```
	
#### Kill a session 

```bash
$ tmux kill-session -t sessionname
```
	
#### Attach to session

```bash
$ tmux attach -t sessionname
```
	
