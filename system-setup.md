# System Setup

## Before you wipe your system 

* Make sure you have your ssh key backed up
* Are there any projects with files you can't get from github or some cloud source?

## Basic config

Keyboard

* Make caps lock the ctrl key
* Max key repeat rate
* Max shortness for delay key repeat rate
* Use standard function keys

Track pad tap to click

Set the dock to auto hide

Set the title bar to auto hide

Automatically hide the menu bar

## Install App Store apps

1Password -> login and setup

* Enable 3rd party app integration

Xcode -> Install Xcode components (open app and install dialog will appear)

Install other misc apps that you use

## Download and install Dropbox -> Configure and add to sidebar in finder

It might be a good idea to download the WorkstationConfig dir first

## Download and install primary browser, Brave

Make this your primary browser

## Download and install Alfredapp

1. Unset spotlight cmd + space keyboard shortcut and add to Alfred 
2. Add Folders, Text Files, and Documents to search results
3. Update appearance 
4. Add custom workflows
5. Add 1password integration

## Download and install terminal app, iTerm2

Show hidden files in finder:

```sh
$ defaults write com.apple.finder AppleShowAllFiles true
```

Enable key hold repeat

```sh
$ defaults write -g ApplePressAndHoldEnabled -bool true
```

## Add ssh key

Pull this over from your flash drive or whatever

## Sym link config files to dropbox folder

In your home directory:

```sh
$ ln -s ~/Dropbox/WorkstationConfig/zshrc.local .zshrc.local
$ ln -s ~/Dropbox/WorkstationConfig/.ssh/config ~/.ssh/config
```

## Install oh-my-zsh

```sh
$ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Install console prompt style

```sh
$ brew tap sambadevi/powerlevel9k; brew install powerlevel9k
```

## Install homebrew

```sh
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Then install some brew packages

```sh
$ brew install rbenv nodenv zsh-syntax-highlighting exa fzf
```

Install Nerd fonts:

```sh
$ brew tap homebrew/cask-fonts
$ brew cask install font-hack-nerd-font
```

Update iTerm2 to work with hack font

## Download dot files and follow directions

Clone the dot files repo into your home directory:

```sh
$ git clone git@github.com:elliotlarson/dotfiles.git
```

Follow directions in README 

There is also a README in the vim directory for setting up vim

## Install more homebrew packages 

```sh 
$ brew install yarn redis postgres@11
```

Install the GitHub CLI:

```sh
$ brew install github/gh/gh
```

TODO: install virtualbox and youtube-dl

## Download and install software

* Chrome
* Firefox
* IntelliJ - (follow setup instructions in `ruby-rubymine-intellij-notes.md`)
* VSCode
* Sketch 
* Figma 
* Table plus 
* Anki
* Microsoft 365 
* Skype
