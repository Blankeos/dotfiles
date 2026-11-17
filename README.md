<h1>🐟 Carlo's Dotfiles & New Machine Setup</h1>

macOS only (for now). The repo installs itself; this README is just the manual leftovers.

## 🚀 Setup

```sh
git clone https://github.com/Blankeos/dotfiles ~/dotfiles   # must be ~/dotfiles (stow)
~/dotfiles/scripts/bootstrap.sh dev desktop media mobile personal   # my laptop
~/dotfiles/scripts/bootstrap.sh dev                                 # agent machine
```

It installs Homebrew, runs each category's Brewfile, `stow`s the configs, then runs
each category's hook (oh-my-zsh, fonts, rustup/bun/uv/claude, cargo/go/bun globals,
`skillshare sync`, `mcp-sync --write`, macOS defaults). Safe to rerun.

The chosen categories are saved to `~/dotfiles/.categories` (gitignored), so later runs need no args:

| Command                     | Does                                          |
| --------------------------- | --------------------------------------------- |
| `bootstrap.sh`              | reinstall/sync this machine's categories      |
| `bootstrap.sh --update`     | `brew upgrade` first, then the same           |
| `uptools`                   | `--update` + self-updaters (uv, rustup, bun, claude, omz) in mprocs |
| `bootstrap.sh --list`       | show categories (`*` = saved here)            |

## 🗂️ Categories

A category is `bootstrap/<name>.Brewfile` + optional `bootstrap/<name>.sh` (non-brew stuff).
New file = new category. `core` is always included.

| Category   | What                                                            |
| ---------- | --------------------------------------------------------------- |
| `core`     | shell, git, nvim, lazygit, yazi, fzf, fonts, oh-my-zsh          |
| `dev`      | languages, cloud CLIs, agents, my cargo/go/bun tools, skills, MCP |
| `desktop`  | terminals, editors, browsers, launchers, work apps, macOS defaults |
| `mobile`   | Android Studio, Xcode tooling, Flutter (fvm), NativeScript. Pulls in `dev` |
| `media`    | recording, video, 3D, game engines                              |
| `personal` | chat, music, games                                              |

Installed something by hand? Add it to the right Brewfile (`brew bundle dump --file=-` shows everything).

## ✋ Manual steps

- **GitHub:** `gh auth login`, `gh auth setup-git` (work: `gh auth switch`, `gh auth status`)
- **Fonts:** use `ZedMono NF Extended` in VSCode/Zed; `ZedMono Nerd Font` + `Extended` in terminals.
  The patched font lives in `fonts/` (from [cabrinha's fork](https://github.com/cabrinha/nerd-fonts/tree/zed-fonts/patched-fonts/ZedMono)).
- **Xcode** (mobile): install from the App Store, then Settings > Components > iOS platform. `xcrun xctrace list devices`
- **Android Studio** (mobile): Settings > Android SDK > SDK Tools > Android SDK Command-line Tools. Then `flutter doctor`.
- **Tinycast:** General > Hyper Key > Capslock ✦. Store extensions: Unicode Symbols Search, Color Picker, Unix Timestamp, OCR.
  Commands > Import Raycast Scripts (`.config/raycast/scripts`). Hotkeys are in `.config/tinycast/settings.json`.
  Raycast: add `~/Applications/Vivaldi Apps` as an application directory (⌘⇧G).
- **Vivaldi:** see [VIVALDI_GUIDE.md](/VIVALDI_GUIDE.md)
- **Logins / licenses / permission prompts** (Accessibility, Screen Recording) for each app.
- **Not on brew:** [Paraspeech](https://paraspeech.com) (license), [Recordly](https://recordly.dev),
  Tuitube (`curl -sf https://termcast.app/r/tuitube | bash`), [cua-driver](https://github.com/trycua/cua),
  Wezterm icon ([script](https://github.com/Blankeos/WeztermChangeIconForMac)).

`desktop.sh` already sets: no autocorrect/auto-capitalize, Tab focus in dialogs, three-finger drag,
hard disks in Finder, Spotlight's ⌘Space off. Logout if any don't stick.

## 💡 Tips

- Finder large files: Cmd+J > Calculate all sizes (per folder, start with Macintosh HD).
- Clean `brew uninstall`: check `~/Library/LaunchAgents`, `/Library/LaunchDaemons`,
  `~/Library/Application Support/<pkg>`, `~/Library/Preferences/<pkg>.plist`.
- `libpq` is keg-only; `.zshrc` already puts it on PATH for `pg_dump`.
- Skills: `skillshare install <user/repo> -s <name>`, or add `~/.config/skillshare/skills/<name>/SKILL.md`, then `skillshare sync`.
