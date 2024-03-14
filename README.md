<h1>🐟 Carlo's Dotfiles & New Machine Setup</h1>

This repository contains instructions for setting up configs and other installations
on my machines. I'll be using MacOS only moving forward but will provide guides for Windows as
well.

<h2>Table of Contents</h2>

- [Install Fonts](#install-fonts)
- [MacOS Setup](#macos-setup)
  - [1. Install](#1-install)
  - [2. Setup Git](#2-setup-git)
  - [3. Setup Starship](#3-setup-starship)

## Install Fonts

- [Zed Mono](https://github.com/zed-industries/zed-fonts/releases) - Set it up on the terminal as well.

## MacOS Setup

#### 1. Install

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
  ```

- Install [Bun](https://bun.sh/docs/installation)

  ```sh
  curl -fsSL https://bun.sh/install | bash # for macOS, Linux, and WSL
  ```

- Install [Mac Mouse Fix](https://github.com/noah-nuebling/mac-mouse-fix)

  ```sh
  brew install mac-mouse-fix
  ```

#### 2. Setup Git

```sh
# Install the GitHub CLI
brew install gh

# Login
gh auth login
```

#### 3. Setup Starship

```sh
# 1. Run
mkdir -p ~/.config && touch ~/.config/starship.toml

# 2. Paste contents of `starship.toml` from here to ~/.config/starship.toml
```
