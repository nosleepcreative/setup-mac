#!/bin/zsh
# Clear the Dock down to Finder and Safari.
# Finder and Trash are always in the Dock and can't be removed.

set -e

# Back up the current Dock layout
backup=~/dock-backup-$(date +%Y%m%d-%H%M%S).plist
defaults export com.apple.dock "$backup"
echo "Saved current Dock layout to $backup"

# Keep only Safari as a pinned app
defaults write com.apple.dock persistent-apps -array \
  '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/Safari.app/</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>'

# Remove folders and stacks on the right side, like Downloads
defaults write com.apple.dock persistent-others -array

# Hide the "recent apps" section
defaults write com.apple.dock show-recents -bool false

# Restart the Dock to apply the changes
killall Dock
