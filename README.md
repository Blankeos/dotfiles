<h1>🐟 Carlo's Dotfiles & New Machine Setup</h1>

This repository contains instructions for setting up configs and other installations
on my machines.

This guide will be mainly **MacOS** only moving forward but will provide alternative guides for Windows as
well.

<h2>Table of Contents</h2>

- [🔤 Install Fonts](#%F0%9F%94%A4-install-fonts)
- [🖥️ MacOS Setup](#%F0%9F%96%A5%EF%B8%8F-macos-setup)
  - [1. Install](#1-install)
  - [2. Setup Git](#2-setup-git)
  - [3. Setup Starship](#3-setup-starship)
  - [Additional](#additional)

## 🔤 Install Fonts

My favorite font is **Zed Mono** and **BlexMono Nerd Font** ⚡️ (The ones that Zed Editor uses).

| Font                                                             | Description                                                                                                                                                                                                                                                                                                          |
| ---------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Zed Mono](https://github.com/zed-industries/zed-fonts/releases) | Official Zed Mono font by zed-industries                                                                                                                                                                                                                                                                             |
| [ZedMono Nerd Font](/fonts/ZedMonoNerdFont)                      | I have my own copy at `"/fonts/ZedMono Nerd Font"`. Downloaded from [cabrinha's fork](https://github.com/cabrinha/nerd-fonts/tree/zed-fonts/patched-fonts/ZedMono) of [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts). You can also download from ryanoasis's repo. I only downloaded the "Extended" |
| [BlexMono Nerd Font](https://www.nerdfonts.com/font-downloads)   | Official Nerd Font                                                                                                                                                                                                                                                                                                   |

> [!IMPORTANT]
> Use `ZedMono NF Extended` in VSCode or Zed (This is the unique name in FontBook)
>
> If that doesn't work, use `Zed Mono Nerd Font`, but make sure that you only downloaded the Extended style.
>
> Use `ZedMono Nerd Font` and `Extended` for Terminal or iTerm.

## 🖥️ MacOS Setup

#### 1. Clone this repo in into `~/dotfiles`. Important for Stow to work

#### 2. Install

- Install [Brew](https://brew.sh/)

  ```
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

- Install [Starship](https://starship.rs/)

  ```sh
  curl -sS https://starship.rs/install.sh | sh
  ```

- Install [OhMyZsh](https://ohmyz.sh/#install)

  ```sh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # Some enhancements I use
  brew install zsh-autosuggestions
  ```

- [x] Better LS (Eza)

  ```sh
  brew install --cask eza # Then make sure to `alias ls="eza"` in your .zshrc.
  # Can now do stuff like
  ls -T # tree, etc.
  ```

- [x] Smarter cd (Zoxide)

  ```sh
  brew install --cask zoxide # Then make sure to `alias cd="z"` and `alias cdi="zi" in your .zshrc.
  cd projects # Jumps to ~/Desktop/Projects very easily, if you've visited it already
  zi # If you want interactive search
  zoxide edit # To delete saved stuff
  ```

- Install [Wezterm](https://wezfurlong.org/wezterm/)

  ```sh
  brew install --cask wezterm # Renders the Nerd Fonts better + better IDE
  ```

  - I also like to change the App Icon [(Script)](https://github.com/Blankeos/WeztermChangeIconForMac)

#### 3. Setup Git

```sh
# Install the GitHub CLI
brew install gh

# Login
gh auth login

# Zed as my default editor (with Git)
git config --global core.editor "zed -w"

# (Additionally) For work if you have multiple accounts
gh auth setup-git # Only need to run once
gh auth switch # switch between logged in accounts.
gh auth status # check which account is logged in.
```

#### 4. Install Configs (NeoVim, Starship, zshrc)

```sh
brew install stow
cd ~/dotfiles
stow . # Now symlinked, you can keep editing and pushing to this repo.
```

#### Additional

<details>
  <summary>
    ⭐️ MacOS Improvements
  </summary>

- [x] Better Backspace on **Terminal** > **Settings** > **Profile** > **Keyboard** > ✅ Use Option as Meta key. (Less used, just use Wezterm)
- [x] Better Backspace on **iTerm2** > **Settings** > **Profile** > **Keys** > **Left Option Key** > ✅ Esc+ (Less used, just use Wezterm)
- [x] Keyboard accessible Native Dialogs > **Settings** > **Keyboard** > **Keyboard Shortcuts** > ✅ Change the way Tab moves focus. Then press Ctrl + Fn + F7.
  - Now, "Tab" or "Shift+Tab" will switch between action in Native Dialogs.
  - "Space" performs the current focused action.
  - "Enter" is always the primary (blue) action.
  - "Cmd+." is always cancel.
  - "Esc" is always cancel.
- [x] Quick Note: If you're uninstalling with `brew uninstall`. Checklist for making sure it's a clean uninstall:
  - Check `~/Library/LaunchAgents` and `/Library/LaunchDaemons` for leftover launchd plists
  - Check `~/Library/Application Support/<package>` for leftover configs
  - Check `~/Library/Preferences/<package>.plist` for leftover preferences

- [x] Better Window management Install [Rectangle](https://rectangleapp.com/) - For window management

  ```sh
  brew install --cask rectangle
  ```

- [x] Better Spotlight. Install [Raycast](http://raycast.com)

  ```sh
  brew install --cask raycast

  # Advanced > Hyper Key > Capslock ✦
  # Extensions via [Install from store] (no list to see them, so just refer here):
  #    - Unicode Symbols Search
  #    - Color Picker
  # Extensions > Add these hotkeys...
  #   - ✦ 1 - Zed
  #   - ✦ 2 - WezTerm
  #   - ✦ 3 - Vivaldi
  #   - ✦ 4 - Spotify
  #   - ✦ F - Finder
  #   - ✦ N - Notion
  #   - ✦ D - Notion
  #   - ✦ S - Slack
  #   - ✦ M - Messenger
  ```

  - Go to System Settings > Keyboard > Keyboard Shortcuts > Spotlight > Show Spotlight Search (off)
  - Add `vivaldi://apps` directory as indexable by Raycast:
    - Extensions > [+] > Add Application Directory > ⌘ Shift G > `~/Applications/Vivaldi Apps`

- [x] Go to System Settings > Keyboard > Text > Edit... >
- [x] Uncheck - "Correct spelling automatically"
- [x] Uncheck - "Capitalize words automatically"

- [x] Install [Mac Mouse Fix](https://github.com/noah-nuebling/mac-mouse-fix) - I think it's better than LogiOptions+.

- [x] Finder Tips to help find large files
  - Check Finder > Settings > Hard disks ✅
  - Do this for some folders only (Start with Macintosh HD): Cmd+J (or View > Show View Options) > Calculate all sizes ✅

  ```sh
  brew install --cask mac-mouse-fix
  ```

</details>

<details>
  <summary>💿 Development-specific installations</summary>

- [x] PNPM - Better node package manager for some projects.

  ```sh
  npm install --global pnpm
  ```

- [x] Node - I prefer to install node via fnm (Nvm but built with Rust).

  ```sh
  brew install fnm
  fnm install 20
  fnm use 20
  ```

- [x] [Bun](https://bun.sh/docs/installation) - Best js/ts runtime & package manager (for me).

  ```sh
  curl -fsSL https://bun.sh/install | bash # for macOS, Linux, and WSL
  ```

- [x] XZ - Need to install this before installing a pyenv version.

  ```sh
  brew install xz
  ```

- [x] Python - I prefer to install python via uv

  ```sh
  # brew install pyenv # (NOT NEEDED ANYMORE)
  # pyenv install 3.12 # or any version
  # pyenv global 3.12
  curl -LsSf https://astral.sh/uv/install.sh | sh # Install uv
  ```

- [x] Go - My compiled language for backend services.

  ```sh
  brew install go
  ```

- [x] Rust - My preferred low-level compiled language.

  ```sh
  curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
  ```

- [x] [Gleam](https://gleam.run/getting-started/installing/) - My preferred functional programming language on the BEAM VM.

  ```sh
  brew install gleam
  ```

- [x] Defold - My preferred game engine.

  ```sh
  brew install --cask defold
  ```

- [x] Android Platform Tools - For `adb devices` and `adb logcat -s defold` (useful for debugging Defold games). Can actually also be installed with Android Studio.

  ```sh
  brew install android-platform-tools
  ```

- [x] Android Studio - For the android simulator and SDK Tools. Haven't used it for anything else.

  ```sh
  brew install --cask android-studio

  # Install Command-line Tools (Needed by flutter doctor)
  - Go to Settings (Cmd + ,) > Language & Frameworks > Android SDK > SDK Tools > Android SDK Command-line Tools (latest) > OK
  ```

- [x] XCode - For the iOS simulator and SDK Tools.

  ```sh
  xcode-select -install # I think you can run any xcode command and it will prompt you to install in App Store.
  xcrun xctrace list device # Check all simulators

  # Install iOS Platform SDK (Needed by flutter doctor)
  - Go to XCode > Settings > Components > Platform Support (Make sure iOS is installed)
  - Go to XCode > Window > Devices & Simulator (Shift + Command + 2)
  ```

- [x] Java - for `keytool` and android tools with defold.

  ```sh
  brew install openjdk
  # Make sure to follow the instructions to symlink it to path so `java -version` works.
  ```

- [x] Cocoapods - For installing dependencies for iOS in mobile projects.

  ```sh
  brew install cocoapods
  ```

- [x] [Flutter](https://docs.flutter.dev/get-started/install) - For mobile development.

  ```sh
  brew tap leoafarias/fvm
  brew install fvm
  fvm install stable
  fvm global stable
  export PATH=$PATH:"$HOME/fvm/default/bin" # Add to .zshrc
  flutter doctor # Check if it's working.
  ```

- [x] OpenCode - Coding agents. Usecases: Coding, quick chatting.

  ```sh
  brew install opencode
  ```

- [x] Lazygit - my usual git workflow, works anywhere.

  ```sh
  brew install lazygit
  brew install git-delta # Better pager for lazygit (it's in my config)
  ```

- [x] Beekeeper Studio - SQL exploration in my GUI. `brew install --cask beekeeper-studio`
- [x] Medis - Redis exploration in my GUI. `brew install --cask medis`
- [x] Yaak - Postman/Bruno alternative (git-based), better, prefer for big projects. `brew install --cask yaak`
- [x] Httpie - Postman alternative, better. (I prefer the web just for quick, so no need to install). `brew install --cask httpie`

</details>

<details>
  <summary>⭐️ Essential Applications</summary>

- [x] Vivaldi - Favorite browser - `brew install --cask vivaldi`
- Config is in [Vivaldi Guide](/VIVALDI_GUIDE.md)

- [x] Handbrake - Video Converter - `brew install --cask handbrake`
- [x] Keycastr - Keypress visualzier - `brew install --cask keycastr`
- [x] Screen Studio - Slick Screen Recorder - `brew install --cask screen-studio`
- [x] Rotato - Cool mockups - `brew install --cask rotato`
- [x] Licecap - GIFs - `brew install --cask licecap`
- [x] FreeFileSync - Essential workflow for file storage. `brew install --cask freefilesync`
- [x] Paraspeech - https://paraspeech.com (I have a license)
- [x] Notion - `brew install --cask notion`
- [x] Shottr - `brew install --caks shottr` (best screenshot app)
- [ ] Clop - https://lowtechguys.com/clop/ (Cool software from lowtechguys, might use)

<!-- - [x] Bruno - API Testing - `brew install --cask bruno` -->

</details>
