#!/bin/zsh
# Set up a new Mac in one go: Xcode Command Line Tools, Homebrew, the Brewfile (or personal/Brewfile if it's there), manual installers,
# the Dock, Spotlight and Mac settings.
# Safe to run again: installed apps are skipped, but the Dock gets reset each time.
#
#   zsh setup.sh

set -e
setopt null_glob
cd "${0:A:h}"

step() { print -P "\n%B==> $1%b"; }

# ── Xcode Command Line Tools ──────────────────────────────────────────────────
# git, compilers and make. Homebrew needs them, and the Intel .pkg doesn't install them.
step "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
  echo "Already installed."
else
  xcode-select --install
  echo "Click Install in the window that opened. Waiting for it to finish..."
  until xcode-select -p &>/dev/null; do sleep 5; done
fi

# ── Homebrew ──────────────────────────────────────────────────────────────────
step "Homebrew"
if [[ $(uname -m) == arm64 ]]; then brew_bin=/opt/homebrew/bin/brew; else brew_bin=/usr/local/bin/brew; fi

if [[ ! -x $brew_bin ]]; then
  if [[ $(uname -m) != arm64 ]]; then
    echo "Intel Mac: install Homebrew with the .pkg first (see README → Usage → Install just the apps), then run this again."
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
# personal/Brewfile includes the main Brewfile, so use it instead when it's here
brewfile=Brewfile
[[ -f personal/Brewfile ]] && brewfile=personal/Brewfile

step "Installing $brewfile (this takes a while)"
# Keep going if a few items fail, e.g. App Store apps when you're not signed in
brew bundle --file=$brewfile || failed_bundle=1

# ── Xcode ─────────────────────────────────────────────────────────────────────
# Only if the Brewfile installed the full Xcode app (personal/Brewfile does)
if [[ -d /Applications/Xcode.app ]]; then
  step "Xcode"
  echo "Accepting the Xcode license and installing its extra components (macOS will ask for your password)"
  sudo xcodebuild -license accept && sudo xcodebuild -runFirstLaunch || echo "Xcode setup failed. Open Xcode once to finish it."
fi

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
launchers=( /Applications/(Alfred*|Raycast).app )
if (( $#launchers )); then
  bash scripts/spotlight.sh
else
  echo "No Alfred or Raycast installed. Leaving ⌘Space for Spotlight."
fi

step "Finder, keyboard and other settings"
zsh scripts/macos.sh

step "After Effects Scripts folder"
zsh scripts/ae-scripts-link.sh

# ── Done ──────────────────────────────────────────────────────────────────────
step "Done"
if (( failed_bundle )); then
  echo "Some Brewfile items didn't install. Sign into the App Store if needed, then run:"
  echo "  brew bundle --file=$brewfile"
fi
echo "Log out and back in so every change takes effect."
echo "Still to do by hand: see Manual installs in the README."
