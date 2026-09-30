#!/bin/zsh
# Mac settings that make everyday design work less fiddly.
# Keyboard changes take effect after you log out and back in.

set -e

# ── Finder ────────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain AppleShowAllExtensions -bool true         # show file extensions (.psd, .aep, .mov)
defaults write com.apple.finder ShowPathbar -bool true                  # show the folder path at the bottom
defaults write com.apple.finder ShowStatusBar -bool true                # show item count and free space
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv       # use list view by default
defaults write com.apple.finder FXDefaultSearchScope -string SCcf       # search the current folder, not the whole Mac
defaults write com.apple.finder _FXSortFoldersFirst -bool true          # put folders above files
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true  # no .DS_Store files on servers
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true      # ...or on USB drives
chflags nohidden ~/Library                                              # show ~/Library (plugin and preset folders)

# ── Saving files ──────────────────────────────────────────────────────────────
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false   # save to your Mac, not iCloud
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true   # open Save dialogs fully expanded
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# ── Keyboard ──────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false      # hold a key to repeat it, instead of the accent menu
defaults write NSGlobalDomain KeyRepeat -int 2                          # repeat keys faster, for nudging layers
defaults write NSGlobalDomain InitialKeyRepeat -int 15                  # start repeating sooner

# ── Dock and Spaces ───────────────────────────────────────────────────────────
defaults write com.apple.dock autohide -bool true                       # hide the Dock until you point at it
defaults write com.apple.dock autohide-delay -float 0                   # show it with no delay
defaults write com.apple.dock mru-spaces -bool false                    # stop macOS reordering your desktops

# ── Screenshots ───────────────────────────────────────────────────────────────
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location ~/Screenshots           # save screenshots here, not the Desktop
defaults write com.apple.screencapture disable-shadow -bool true        # no drop shadow on window screenshots

# Restart the apps so the changes show up
killall Finder Dock SystemUIServer 2>/dev/null || true

echo "Mac settings applied. Log out and back in for the keyboard changes."
