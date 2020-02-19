# Doom Emacs

## Installation and Config

### Install EmacsPlus

https://github.com/d12frosted/homebrew-emacs-plus

This may not be necessary in the future, but this is a fork of the base emacs brew formula that has some options pre-configured.  It's referenced in a popular getting started video for emacs-doom, and the emacs wiki also references it in it's installtion guide. 

```bash
$ brew tap d12frosted/emacs-plus
$ brew install emacs-plus --without-spacemacs-icon # this is default for some reason
```

### Install Doom

```bash
$ git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
$ git checkout develop # this may not still be necessary, but I saw this in a couple of tutorials
$ ~/.emacs.d/bin/doom install
```

The tutorials I saw showed installing fonts after opening Emacs, but when I installed from develop, the fonts got auto-installed.

### Config Doom

Open up the custom config file

`spc + f + p`

Most of your config will go in the `init.el` file.

#### Set font 

Comment out the current font line in the `config.el` and add this:

```lisp
(setq doom-font (font-spec :family "JetBrains Mono" :size 13))
```

#### Treeview

After installing everything, I was expecting to see a file browser.  It's not installed by default.  This needs to be configured to work.

After launching emacs, open the private config `spc o P` and then open the file `~/doom.d/init.el`.  Look for the line that says `;;neotree` and remove the `;;` to uncomment it.  Save the file, close Emacs and then `refresh` doom:

```bash
$ ~/.emacs.d/bin/doom refresh
```

At this point, I added `~/.emacs.d/bin` to my load path.

#### Fuzzy file search

To get fuzzy searching for files, change the `ivy` part of the config file to:

```lisp
(ivy +fuzzy +prescient)
```

#### Ruby 

#### Evil mode

I'm used to using the key chord `ctrl + c` to exit insert mode to normal mode.  This doesn't work out of the box with Doom.  To configure it, open the config file `init.el` and add:

```lisp
(define-key evil-insert-state-map (kbd "C-c") 'evil-normal-state)
```

## Basic Usage

### Open configuration file 

`spc + f + p` and edit the `config.el` file.

### Open a file

From within emacs:

`spc + .` and then you can navigate the folder structure to the desired file.

### Opening a project

The first time you open a project: Open emacs and hit the cord `spc + f + f` and navigate to a project's directory.  Once you open a file in a directory with a `.git` directory, the project tool Projectile will recognize this as a project and add it to the list.

After the first time you open a project: `spc + p + p`

### Open a file in a project with fuzzy search

After fuzzy search has been enabled for ivy

`spc + spc`

### Open the file browser

`spc + o + p`

### Working with window splits

To see the options

`spc + w`

vertical split: `spc + w + v` 
horizontal split: `spc + w + s` 
close split: `spc + w + c`

### Open Neotree

`spc + o + p`
