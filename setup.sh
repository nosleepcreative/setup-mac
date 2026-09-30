#!/bin/zsh
# Set up a new Mac in one go: Homebrew, the Brewfile, manual installers, the Dock, Spotlight and Mac settings.
# Safe to run again: installed apps are skipped, but the Dock gets reset each time.
#
#   zsh setup.sh

set -e
setopt null_glob
cd "${0:A:h}"

step() { print -P "\n%B==> $1%b"; }

# ── Homebrew ──────────────────────────────────────────────────────────────────
step "Homebrew"
if [[ $(uname -m) == arm64 ]]; then brew_bin=/opt/homebrew/bin/brew; else brew_bin=/usr/local/bin/brew; fi

if [[ ! -x $brew_bin ]]; then
  if [[ $(uname -m) != arm64 ]]; then
    echo "Intel Mac: install Homebrew with the .pkg first (see README → Intel Macs), then run this again."
    exit 1
  fi
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$($brew_bin shellenv zsh)"
# Put brew on the PATH in new Terminal windows (Intel's /usr/local/bin already is)
if [[ $(uname -m) == arm64 ]] && ! grep -qs 'brew shellenv' ~/.zprofile; then
  echo "eval \"\$($brew_bin shellenv zsh)\"" >> ~/.zprofile
fi
brew --version | head -1

# ── Apps and tools ────────────────────────────────────────────────────────────
step "Installing the Brewfile (this takes a while)"
# Keep going if a few items fail, e.g. App Store apps when you're not signed in
brew bundle --file=Brewfile || failed_bundle=1

# ── Manual installers ─────────────────────────────────────────────────────────
step "Manual installers"
installers=( installers/*.(dmg|pkg) )
if (( $#installers )); then
  zsh scripts/install-manual.sh
else
  echo "Nothing in installers/. Skipping."
fi

# ── Mac settings ──────────────────────────────────────────────────────────────
step "Dock"
zsh scripts/dock.sh

step "Spotlight shortcut"
bash scripts/spotlight.sh

step "Finder, keyboard and other settings"
zsh scripts/macos.sh

step "After Effects Scripts folder"
zsh scripts/ae-scripts-link.sh

# ── Done ──────────────────────────────────────────────────────────────────────
step "Done"
if (( failed_bundle )); then
  echo "Some Brewfile items didn't install. Sign into the App Store if needed, then run:"
  echo "  brew bundle --file=Brewfile"
fi
echo "Log out and back in so every change takes effect."
echo "Still to do by hand: see Manual installs in the README."
