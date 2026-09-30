#!/bin/zsh
# Install apps that aren't on Homebrew from .dmg and .pkg files in installers/.
#
#   zsh install-manual.sh             install everything in installers/
#   zsh install-manual.sh <file>...   install only these files

set -e
setopt extended_glob null_glob

files=( ${@:A} )
cd "${0:A:h:h}"  # repo root, where installers/ is
(( $#files )) || files=( installers/*.(dmg|pkg) )

if (( ! $#files )); then
  echo "No installers found. Put .dmg or .pkg files in installers/ first."
  exit 1
fi

install_pkg() {
  echo "Installing ${1:t} (macOS will ask for your password)"
  sudo installer -pkg "$1" -target /
}

install_dmg() {
  local mnt=$(mktemp -d /tmp/installer.XXXXXX)
  hdiutil attach -nobrowse -readonly -mountpoint "$mnt" "$1" >/dev/null
  {
    local pkgs=( "$mnt"/*.(pkg|mpkg) ) apps=( "$mnt"/*.app ) app
    if (( $#pkgs )); then
      for p in $pkgs; do install_pkg "$p"; done
    elif (( $#apps )); then
      for app in $apps; do
        if [[ ${app:t} == (#i)*(install|setup)* ]]; then
          # An installer app: run it and wait until you quit it
          echo "Opening ${app:t}. Finish the installer, then quit it to continue."
          open -W "$app"
        else
          # A plain app: copy it into Applications, replacing any older copy
          echo "Copying ${app:t} to /Applications"
          rm -rf "/Applications/${app:t}"
          ditto "$app" "/Applications/${app:t}"
        fi
      done
    else
      echo "Didn't find an app or .pkg in ${1:t}. Open it in Finder to install it by hand."
    fi
  } always {
    hdiutil detach "$mnt" -quiet || echo "Couldn't eject ${1:t}. Eject it in Finder."
  }
}

for f in $files; do
  echo "==> ${f:t}"
  case $f in
    *.pkg) install_pkg "$f" ;;
    *.dmg) install_dmg "$f" ;;
    *)     echo "Skipping ${f:t}: not a .dmg or .pkg" ;;
  esac
done
