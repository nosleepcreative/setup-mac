# setup-mac

A [Brewfile](Brewfile) for setting up a new Mac with my usual tools and apps.

## What is Homebrew?

[Homebrew](https://brew.sh) is like an App Store you use from the Terminal. Instead of visiting a dozen websites and dragging each app into Applications, you type one command and Homebrew downloads and installs it for you. It can also keep everything up to date with `brew upgrade`.

A **Brewfile** is a shopping list for Homebrew. It lists every app and tool you want, and `brew bundle` installs the whole list in one go. That makes setting up a new Mac mostly automatic.

The Brewfile has a few kinds of entries:

- `brew`: command-line tools, like `ffmpeg` or `yt-dlp`
- `cask`: regular Mac apps, like Figma, Slack or Chrome
- `mas`: Mac App Store apps, like Keynote
- `npm`: JavaScript tools, installed with Node's package manager

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
