# Doom Emacs

## Getting Started

### Open the configuration file

`spc + f + p`

Most of your config will go in the `init.el` file.

#### Treeview

After installing everything, I was expecting to see a file browser.  It's not installed by default.  This needs to be configured to work.

After launching emacs, open the private config `spc o P` and then open the file `~/doom.d/init.el`.  Look for the line that says `;;treeview` and remove the `;;` to uncomment it.  Save the file, close Emacs and then `refresh` doom:

```bash
$ ~/.emacs.d/bin/doom refresh
```

At this point, I added `~/.emacs.d/bin` to my load path.

#### Fuzzy file search

To get fuzzy searching for files, change the `ivy` part of the config file to:

```lisp
(ivy +fuzzy +prescient)
```

### Opening a project

The first time you open a project: Open emacs and hit the cord `spc + f + f` and navigate to a project's directory.  Once you open a file in a directory with a `.git` directory, the project tool Projectile will recognize this as a project and add it to the list.

After the first time you open a project: `spc + p + p`

### Open a file in a project

After fuzzy search has been enabled for ivy

`spc + spc`

### Open the file browser

`spc + o + p`
