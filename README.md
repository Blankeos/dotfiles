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

My favorite font is **Zed Mono** ⚡️.

| Font                                                             | Description                                                                                                                                                                                                                                                                                                          |
| ---------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Zed Mono](https://github.com/zed-industries/zed-fonts/releases) | Official Zed Mono font by zed-industries                                                                                                                                                                                                                                                                             |
| [ZedMono Nerd Font](/fonts/ZedMonoNerdFont)                      | I have my own copy at `"/fonts/ZedMono Nerd Font"`. Downloaded from [cabrinha's fork](https://github.com/cabrinha/nerd-fonts/tree/zed-fonts/patched-fonts/ZedMono) of [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts). You can also download from ryanoasis's repo. I only downloaded the "Extended" |

> [!IMPORTANT]
> Use `ZedMono NF Extended` in VSCode or Zed (This is the unique name in FontBook)
>
> If that doesn't work, use `Zed Mono Nerd Font`, but make sure that you only downloaded the Extended style.
>
> Use `ZedMono Nerd Font` and `Extended` for Terminal or iTerm.

## 🖥️ MacOS Setup

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

- Install [iTerm2](https://iterm2.com/)

  ```sh
  brew install iTerm2 # Renders the Nerd Fonts better.
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

#### Additional

<details>
  <summary>
    ⭐️ MacOS Improvements
  </summary>

- [x] Better Backspace on **Terminal** > **Settings** > **Profile** > **Keyboard** > ✅ Use Option as Meta key.
- [x] Better backspace on **iTerm2** > **Settings** > **Profile** > **Keys** > **Left Option Key** > ✅ Esc+
- [x] Install [Rectangle](https://rectangleapp.com/) - For window management (Choose the 'Rectangle' keybind setting).
  ```sh
  brew install --cask rectangle
  ```
- [x] Install [Mac Mouse Fix](https://github.com/noah-nuebling/mac-mouse-fix) - I think it's better than LogiOptions+.

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

- [x] Node - I prefer to install node via nvm.

  ```sh
  brew install nvm
  nvm install 20
  nvm use 20
  ```

- [x] [Bun](https://bun.sh/docs/installation) - Best js/ts runtime & package manager (for me).

  ```sh
  curl -fsSL https://bun.sh/install | bash # for macOS, Linux, and WSL
  ```

- [x] XZ - Need to install this before installing a pyenv version.
  ```sh
  brew install xz
  ```
- [x] Python - I prefer to install python via pyenv.

  ```sh
  brew install pyenv
  ```

- [x] Go - My compiled language for backend services.

  ```sh
  brew install go
  ```

- [x] Rust - My preferred low-level compiled language.
  ```sh
  curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
  ```

</details>
