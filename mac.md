# Mac Notes

##### removing swoosh animation

	$ defaults write com.apple.dock workspaces-swoosh-animation-off -bool YES && killall Dock

#### play a system sound on the command line

	$ afplay /System/Library/Sounds/Funk.aiff