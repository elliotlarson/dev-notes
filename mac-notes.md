# Mac Notes

## Play a system sound on the command line

```bash
$ afplay /System/Library/Sounds/Funk.aiff
```

## Show hidden files in finder

```bash
$ defaults write com.apple.finder AppleShowAllFiles YES
$ killall Finder
```

## Allow keyboard hold down repeat

```bash
$ defaults write -g ApplePressAndHoldEnabled -bool false
```

## Use zshell by default

```bash
$ sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
```

## Create install USB drive

Download Sierra (or current Mac OS) via the AppStore App.  Cancel out of the installer window when it loads up after it downloads.

The installer app will be in the Applications directory.

After inserting the USB stick, run the following command on the terminal.  Note this expects the USB drive to be named `Untitled`:

```bash
$ sudo /Applications/Install\ macOS\ Sierra.app/Contents/Resources/createinstallmedia --volume /Volumes/Untitled --applicationpath /Applications/Install\ macOS\ Sierra.app
```
