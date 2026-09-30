# setup-mac

A [Brewfile](Brewfile) for setting up a new Mac with my usual tools and apps.

It's tailored for a **creative and motion designer**. Alongside everyday apps, it installs design and 3D tools (Adobe Creative Cloud, Figma, Blender, Cinema 4D), video and streaming apps (DaVinci Resolve, OBS, HandBrake), and command-line tools for working with images and video (`ffmpeg`, `imagemagick`, `yt-dlp`). It also includes handy extras like ZXPInstaller for installing Adobe extensions and KeyCastr for showing keystrokes in tutorials. Take what's useful and comment out the rest.

## What is Homebrew?

[Homebrew](https://brew.sh) is like an App Store you use from the Terminal. Instead of visiting a dozen websites and dragging each app into Applications, you type one command and Homebrew downloads and installs it for you. It can also keep everything up to date with `brew upgrade`.

A **Brewfile** is a shopping list for Homebrew. It lists every app and tool you want, and `brew bundle` installs the whole list in one go. That makes setting up a new Mac mostly automatic.

The Brewfile has a few kinds of entries:

- `brew`: command-line tools, like `ffmpeg` or `yt-dlp`
- `cask`: regular Mac apps, like Figma, Slack or Chrome
- `mas`: Mac App Store apps, like Keynote
- `npm`: JavaScript tools, installed with Node's package manager

## Why use Homebrew?

- 💼 **Great for contractors and freelancers.** If clients or studios hand you a new laptop for each job, you can get it ready to work on in one step, instead of rebuilding your setup from memory every time.
- ⚡ **Set up a new Mac in one go.** Run one command and walk away, instead of spending an afternoon downloading installers.
- 🔄 **Update everything at once.** `brew upgrade` updates your apps and tools together, so you don't have to click through each app's update prompt. Apps that update themselves (like Chrome) are skipped unless you add `--greedy`.
- 🧹 **Uninstall cleanly.** `brew uninstall --cask <app>` removes an app, and adding `--zap` also clears out its leftover settings files.
- 🛠️ **Get tools you can't download normally.** Many command-line tools like `ffmpeg` and `imagemagick` have no simple Mac installer. Homebrew handles them, along with everything they depend on.
- 📋 **Keep a record of your setup.** The Brewfile is a list of everything you use. Keep it on GitHub and you can rebuild your Mac anytime, or share your setup with teammates.

## Usage

1. Sign into the App Store app, so the `mas` entries can install.
2. On an Intel Mac, install Homebrew first (see [Intel Macs](#intel-macs) below).
3. Open Terminal and paste this in. A new Mac doesn't have `git` yet, so this downloads the repo as a zip instead:

   ```bash
   curl -L https://github.com/nosleepcreative/setup-mac/archive/master.tar.gz | tar xz && cd setup-mac-master && zsh setup.sh
   ```

[setup.sh](setup.sh) does everything in order:

- installs Homebrew, if it isn't already
- installs everything in the Brewfile
- runs anything in `installers/` (see [Manual installs](#manual-installs))
- cleans up the Dock
- frees up ⌘Space
- changes Finder, keyboard and other Mac settings (see [Mac settings](#mac-settings))
- links the After Effects Scripts folder into `~/Documents/Adobe`

It asks for your password a few times. You can run it again. Homebrew skips anything that's already installed, but the Dock gets reset to Finder and Safari each time.

To install only the Brewfile:

```bash
brew bundle --file=Brewfile
```

## Mac settings

[macos.sh](scripts/macos.sh) changes a few settings that get in the way of design work:

```bash
zsh scripts/macos.sh
```

- **Finder:** shows file extensions, the folder path and free space, uses list view with folders first, searches the current folder, and shows `~/Library` so you can find plugin and preset folders
- **No more `.DS_Store` files** on servers and USB drives, so client drives stay clean
- **Saving:** saves to your Mac instead of iCloud, and opens Save dialogs fully expanded
- **Keyboard:** faster key repeat for nudging layers with the arrow keys, and holding a key repeats it instead of showing the accent menu
- **Dock:** hides until you point at it, and macOS stops reordering your desktops
- **Screenshots:** saved to `~/Screenshots` instead of the Desktop, without the drop shadow

Log out and back in for the keyboard changes to work. Each line in the script has a comment, so delete any you don't want before running it.

### Clean up the Dock

A new Mac comes with a Dock full of Apple apps. [dock.sh](scripts/dock.sh) clears it down to just Finder and Safari, removes the Downloads stack, and hides the recent apps section:

```bash
zsh scripts/dock.sh
```

It saves your current layout to a `dock-backup-<date>.plist` file in your home folder first. To put the old Dock back, use the file name the script printed:

```bash
defaults import com.apple.dock ~/dock-backup-<date>.plist && killall Dock
```

Apps that are open still show in the Dock until you quit them. Finder and Trash always stay.

### Free up ⌘Space

If you use Raycast or Alfred, [spotlight.sh](scripts/spotlight.sh) turns off Spotlight's ⌘Space shortcut so the launcher can use it instead:

```bash
bash scripts/spotlight.sh
```

Then set ⌘Space as the shortcut in Raycast or Alfred's settings. Spotlight still opens from the magnifying glass in the menu bar. To turn the shortcut back on, go to System Settings → Keyboard → Keyboard Shortcuts → Spotlight.

### After Effects Scripts folder

After Effects keeps its scripts inside the app, at `/Applications/Adobe After Effects 20xx/Scripts`. [ae-scripts-link.sh](scripts/ae-scripts-link.sh) puts a link to that folder in `~/Documents/Adobe/After Effects 20xx` (the newest version you have), so it sits next to your presets:

```bash
zsh scripts/ae-scripts-link.sh
```

The real folder has to stay inside the app, because that's the only place After Effects loads scripts from. It belongs to the system, so Finder asks for your password when you add scripts through the link.

The `~/Documents` folder only appears after you open After Effects once. If it's missing, open After Effects and run the script again.

## Intel Macs

The official install script now refuses to run on Intel Macs:

```
Homebrew on macOS is only supported on Apple Silicon processors!
```

### Workaround: use the `.pkg` installer

1. Download `Homebrew.pkg` from the [Homebrew 6.0.22 release](https://github.com/Homebrew/brew/releases/tag/6.0.22).
2. Open it and follow the installer.
3. Check that it works:

   ```bash
   brew --version
   ```

On Intel, Homebrew installs to `/usr/local`, which is already on your `PATH`, so there's no `brew shellenv` step.

Tested with Homebrew 6.0.22 on macOS 26.6 (Intel). Intel Macs are no longer a supported Homebrew platform, so expect some formulae (e.g. `ffmpeg`, `imagemagick`) to build from source, which can be slow.

### Issue: existing Homebrew folder

If an earlier install attempt left a Homebrew folder behind, the `.pkg` installer fails. Remove the leftover install, then run the `.pkg` again:

```bash
sudo rm -rf /usr/local/Homebrew
```

Only do this when Homebrew isn't working yet. It deletes the Homebrew installation. If you have a working Homebrew you want to remove cleanly, use the official [uninstall script](https://github.com/Homebrew/install#uninstall-homebrew) instead.

## Manual installs

These aren't available through Homebrew:

- [DaVinci Resolve](https://www.blackmagicdesign.com/products/davinciresolve)
- [aescripts + aeplugins Manager](https://aescripts.com/learn/aescripts-aeplugins-manager-app/)
- [Overlord](https://www.battleaxe.co/overlord): sends shapes from Illustrator straight into After Effects

Download their `.dmg` or `.pkg` files into the `installers/` folder. If they're there before you run `setup.sh`, it installs them for you. Otherwise, install them all in one go:

```bash
zsh scripts/install-manual.sh
```

Or install just one:

```bash
zsh scripts/install-manual.sh "installers/aescripts + aeplugins manager (setup).dmg"
```

For each file, the script either copies the app into Applications, runs the `.pkg` (macOS asks for your password), or opens the app's own installer and waits for you to finish it.

The `installers/` folder isn't uploaded to GitHub. The files are large and belong to other companies, so download fresh copies on each new Mac.
