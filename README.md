# setup-mac

A [Brewfile](Brewfile) for setting up a new Mac with my usual tools and apps.

It's tailored for a **creative and motion designer**. Alongside everyday apps, it installs design and 3D tools (Adobe Creative Cloud, Figma, Blender), video and streaming apps (DaVinci Resolve, OBS, HandBrake), and command-line tools for working with images and video (`ffmpeg`, `imagemagick`, `yt-dlp`). It also includes handy extras like ZXPInstaller for installing Adobe extensions and KeyCastr for showing keystrokes in tutorials. Take what's useful and comment out the rest.

## What is Homebrew?

[Homebrew](https://brew.sh) is like an App Store you use from the Terminal. Instead of visiting a dozen websites and dragging each app into Applications, you type one command and Homebrew downloads and installs it for you. It can also keep everything up to date with `brew upgrade`.

A **Brewfile** is a shopping list for Homebrew. It lists every app and tool you want, and `brew bundle` installs the whole list in one go. That makes setting up a new Mac mostly automatic.

The Brewfile has a few kinds of entries:

- `brew`: command-line tools, like `ffmpeg` or `yt-dlp`
- `cask`: regular Mac apps, like Figma, Slack or Chrome
- `mas`: Mac App Store apps, like Keynote
- `npm`: JavaScript tools, installed with Node's package manager

## Why use Homebrew?

- **Set up a new Mac in one go.** Run one command and walk away, instead of spending an afternoon downloading installers.
- **Update everything at once.** `brew upgrade` updates your apps and tools together, so you don't have to click through each app's update prompt. Apps that update themselves (like Chrome) are skipped unless you add `--greedy`.
- **Uninstall cleanly.** `brew uninstall --cask <app>` removes an app, and adding `--zap` also clears out its leftover settings files.
- **Get tools you can't download normally.** Many command-line tools like `ffmpeg` and `imagemagick` have no simple Mac installer. Homebrew handles them, along with everything they depend on.
- **Keep a record of your setup.** The Brewfile is a list of everything you use. Keep it on GitHub and you can rebuild your Mac anytime, or share your setup with teammates.

## Usage

1. Install [Homebrew](https://brew.sh) (on an Intel Mac, see [Intel Macs](#intel-macs) below).
2. Sign into the App Store app, so the `mas` entries can install.
3. Install everything in the Brewfile:

   ```bash
   brew bundle --file=Brewfile
   ```

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

### Apple Silicon–only casks

Some casks don't install on Intel and are commented out in the Brewfile:

- `raycast`: the Homebrew version requires Apple Silicon.

## Manual installs

These aren't available through Homebrew:

- [DaVinci Resolve](https://www.blackmagicdesign.com/products/davinciresolve)
- [aescripts + aeplugins Manager](https://aescripts.com/learn/aescripts-aeplugins-manager-app/)
