# setup-mac

A [Brewfile](Brewfile) and a few scripts for setting up a new Mac, aimed at **creative and motion designers**.

It installs design and 3D tools (Adobe Creative Cloud, Figma, Blender, Cinema 4D), video apps (HandBrake, IINA, VLC), everyday apps, and command-line video tools (`ffmpeg`, `gifski`, `yt-dlp`). Take what's useful and comment out the rest.

My own extras are in [personal/Brewfile](personal/Brewfile) (see [Personal apps](#personal-apps)).

## What is Homebrew?

[Homebrew](https://brew.sh) is an App Store you use from the Terminal: one command downloads and installs an app, and `brew upgrade` keeps everything up to date.

A **Brewfile** is a shopping list for Homebrew. `brew bundle` installs the whole list in one go. It has a few kinds of entries:

- `brew`: command-line tools, like `ffmpeg`
- `cask`: regular Mac apps, like Figma or Chrome
- `mas`: Mac App Store apps, like Magnet
- `npm`: JavaScript tools

## Why use Homebrew?

- 💼 **Great for freelancers.** Get each new client laptop ready in one step, instead of rebuilding your setup from memory.
- ⚡ **Set up a new Mac in one go.** Run one command and walk away.
- 🔄 **Update everything at once.** `brew upgrade` updates all your apps and tools. Apps that update themselves (like Chrome) are skipped unless you add `--greedy`.
- 🧹 **Uninstall cleanly.** `brew uninstall --cask <app>` removes an app, and `--zap` clears its leftover settings too.
- 🛠️ **Get tools with no Mac installer**, like `ffmpeg`, along with everything they depend on.
- 📋 **Keep a record of your setup.** Keep the Brewfile on GitHub to rebuild your Mac anytime or share it with teammates.

## Before you wipe your old Mac

List what's installed, and save it somewhere off the Mac (iCloud Drive, Dropbox or a USB drive).

This saves a Brewfile of everything from Homebrew and the App Store, plus `apps.txt`, a list of every app, including ones downloaded from websites:

```bash
mkdir -p ~/Desktop/mac-backup
brew bundle dump --file=~/Desktop/mac-backup/Brewfile
ls /Applications > ~/Desktop/mac-backup/apps.txt
```

Add anything you want to keep to [personal/Brewfile](personal/Brewfile), or to [Manual installs](#manual-installs) if it isn't on Homebrew.

To check what's installed at any point, list the apps installed with Homebrew, the command-line tools you installed yourself, and your Mac App Store apps:

```bash
brew list --cask
brew leaves --installed-on-request
mas list
```

## Usage

### Install just the apps

1. Install the Xcode Command Line Tools (`git`, compilers). Homebrew needs them:

   ```bash
   xcode-select --install
   ```

   Click **Install** in the window that pops up and wait for it to finish. If it says they're already installed, move on.

2. Install [Homebrew](https://brew.sh):

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

   When it finishes, run the commands it shows under **Next steps**, so Terminal can find `brew`.

   **On an Intel Mac**, that script refuses to run ("Homebrew on macOS is only supported on Apple Silicon processors!"). Instead:

   1. Download `Homebrew.pkg` from the [Homebrew 6.0.22 release](https://github.com/Homebrew/brew/releases/tag/6.0.22), open it and follow the installer.
   2. Check it works with `brew --version`. There's no Next steps on Intel: `/usr/local` is already on your `PATH`.

   If the `.pkg` fails because an earlier attempt left a Homebrew folder behind, remove it and run the `.pkg` again. Only do this when Homebrew isn't working yet; to remove a working Homebrew, use the official [uninstall script](https://github.com/Homebrew/install#uninstall-homebrew).

   ```bash
   sudo rm -rf /usr/local/Homebrew
   ```

   Tested with Homebrew 6.0.22 on macOS 26.6. Intel is no longer supported, so some tools (e.g. `ffmpeg`) may build from source, which is slow.

3. Sign into the App Store app, so the `mas` entries can install.
4. Install everything in the Brewfile, straight from GitHub:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/nosleepcreative/setup-mac/master/Brewfile | brew bundle --file=-
   ```

### Full setup

To install the apps and also change Mac settings, clean up the Dock and more:

1. Sign into the App Store app, so the `mas` entries can install.
2. On an Intel Mac, install the Command Line Tools and Homebrew first (see [steps 1 and 2 above](#install-just-the-apps)).
3. Paste this into Terminal. It downloads the repo as an archive, since a new Mac doesn't have `git` yet:

   ```bash
   curl -fsSL https://github.com/nosleepcreative/setup-mac/archive/master.tar.gz | tar xz && cd setup-mac-master && zsh setup.sh
   ```

[setup.sh](setup.sh) then:

- installs the Xcode Command Line Tools (`git`, compilers), if needed. Click **Install** in the window that pops up
- installs Homebrew, if needed
- installs the Brewfile, or `personal/Brewfile` if it's there
- runs anything in `installers/` (see [Manual installs](#manual-installs))
- cleans up the Dock
- frees up ⌘Space, if Alfred or Raycast is installed
- changes Finder, keyboard and other [Mac settings](#mac-settings)

It asks for your password a few times. It's safe to run again: installed apps are skipped, but the Dock is reset each time.

## Mac settings

Each script below runs straight from GitHub, like the Homebrew installer, so you don't need to download the repo. Click its name to read it first.

[macos.sh](scripts/macos.sh) changes settings that get in the way of design work:

```bash
curl -fsSL https://raw.githubusercontent.com/nosleepcreative/setup-mac/master/scripts/macos.sh | zsh
```

Or from a downloaded copy of this repo: `zsh scripts/macos.sh`

- **Finder:** shows file extensions, the path bar and free space; list view with folders first; searches the current folder; shows `~/Library` for plugin and preset folders
- **No `.DS_Store` files** on servers and USB drives
- **Saving:** to your Mac instead of iCloud, with Save dialogs fully expanded
- **Keyboard:** faster key repeat for nudging layers, and holding a key repeats it instead of showing accents
- **Dock:** hides until you point at it; macOS stops reordering your desktops
- **Screenshots:** saved to `~/Screenshots`, without the drop shadow

Log out and back in for the keyboard changes. Every line in the script is commented. To skip some, download the repo and delete those lines before running it.

### Clean up the Dock

[dock.sh](scripts/dock.sh) clears the Dock down to Finder and Safari, removes the Downloads stack and hides recent apps:

```bash
curl -fsSL https://raw.githubusercontent.com/nosleepcreative/setup-mac/master/scripts/dock.sh | zsh
```

Or from a downloaded copy of this repo: `zsh scripts/dock.sh`

It backs up your layout first. To restore it, use the file name it printed:

```bash
defaults import com.apple.dock ~/dock-backup-<date>.plist && killall Dock
```

### Free up ⌘Space

[spotlight.sh](scripts/spotlight.sh) turns off Spotlight's ⌘Space shortcut so Alfred or Raycast can use it:

```bash
curl -fsSL https://raw.githubusercontent.com/nosleepcreative/setup-mac/master/scripts/spotlight.sh | bash
```

Or from a downloaded copy of this repo: `bash scripts/spotlight.sh`

Then set ⌘Space in the launcher's settings. Spotlight still opens from the menu bar. To undo, go to System Settings → Keyboard → Keyboard Shortcuts → Spotlight.

## Manual installs

These aren't on Homebrew:

- [DaVinci Resolve](https://www.blackmagicdesign.com/products/davinciresolve)
- [aescripts + aeplugins Manager](https://aescripts.com/learn/aescripts-aeplugins-manager-app/) ([dmg](https://updates.aescripts.com/updater/mac/aescripts%20+%20aeplugins%20manager%20(setup).dmg))
- [Overlord](https://www.battleaxe.co/overlord) ([dmg](https://overlord-release.battleaxe.co/download/dmg))

Put their `.dmg` or `.pkg` files in `installers/` and `setup.sh` installs them. Or install them yourself, all at once or one at a time:

```bash
zsh scripts/install-manual.sh
zsh scripts/install-manual.sh "installers/aescripts + aeplugins manager (setup).dmg"
```

The script copies each app into Applications, runs the `.pkg`, or opens the app's installer and waits for you to finish.

`installers/` isn't uploaded to GitHub, so download fresh copies on each new Mac.

## Personal apps

[personal/Brewfile](personal/Brewfile) is my own setup. It loads the whole main Brewfile, then adds my extras: Bambu Studio, Obsidian, OBS and so on. When the file is there, `setup.sh` installs it instead of the main Brewfile.

For your own Mac, delete it or replace my extras with yours. Keep the `instance_eval` line at the top, which loads the main Brewfile. Keeping additions there, rather than in the main Brewfile, makes it easy to pull in updates later.

```bash
brew bundle --file=personal/Brewfile
```
