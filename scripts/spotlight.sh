#!/bin/bash
# Turn off Spotlight's ⌘Space shortcut, so Raycast or Alfred can use it instead.
# Spotlight still opens from the magnifying glass in the menu bar.

set -e

# Shortcut 64 is "Show Spotlight search". The numbers are the Space key (49) and ⌘ (1048576).
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
  '<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>'

# Apply the change without logging out
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u \
  || echo "Log out and back in to finish turning off the shortcut."

echo "Turned off ⌘Space for Spotlight."
