#!/bin/zsh
# Put a link to After Effects' Scripts folder in ~/Documents/Adobe/After Effects 20xx, next to your presets.
# The real folder stays inside the After Effects app, which is the only place After Effects loads scripts from.

set -e
setopt extended_glob

ae=( ~/Documents/Adobe/After\ Effects\ 20<->(N/On[1]) )  # newest version first
if (( ! $#ae )); then
  echo "No After Effects folder in ~/Documents/Adobe yet. Open After Effects once, then run this again."
  exit 0
fi

scripts="/Applications/Adobe ${ae:t}/Scripts"
if [[ ! -d $scripts ]]; then
  echo "Couldn't find $scripts. Is ${ae:t} installed?"
  exit 0
fi

link="$ae/Scripts"
if [[ -e $link || -L $link ]]; then
  echo "${ae:t} already has a Scripts item. Leaving it alone."
else
  ln -s "$scripts" "$link"
  echo "Linked Scripts into ~/Documents/Adobe/${ae:t}"
fi
