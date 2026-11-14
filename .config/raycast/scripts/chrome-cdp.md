# Chrome CDP

Raycast script that launches a dedicated Chrome instance with remote debugging
for `agent-browser`. One instance per identity (separate user-data-dir + port),
so work and personal agents never share sessions and can run at the same time.

## Instances

| Name | CDP port | Profile dir (persistent, gitignored) |
|---|---|---|
| `work` | `9222` | `~/dotfiles/.local/chrome-cdp` (original dir, kept so logins persist) |
| `personal` | `9223` | `~/dotfiles/.local/chrome-cdp-personal` |

Script: `~/.config/raycast/scripts/chrome-cdp.sh` (via dotfiles).

Sign into sites once in each window — cookies/logins stick in the dir across
launches.

## Tinycast setup (current launcher)

Tinycast does NOT read the `@raycast.argument1` header (dropdown). Scripts are
imported once as a plain custom command, so the argument must be set up by hand.

Settings → Commands → **Chrome CDP** → Edit:

| Field | Value |
|---|---|
| Command | `/Users/carlo/dotfiles/.config/raycast/scripts/chrome-cdp.sh "$1"` |
| Argument 1 | name `Profile` (any label), **optional** |

- The `"$1"` is required. Tinycast hands arguments to zsh as positional
  parameters and never splices them into the command text, so without `"$1"`
  the script never receives the value and always falls back to `work`.
- Keep the quotes. An empty value still launches `work`.
- In the launcher: select **Chrome CDP**, type `work` or `personal` in the
  argument field, hit Return.
- Optional: make two custom commands instead (`... chrome-cdp.sh work` and
  `... chrome-cdp.sh personal`) for separate aliases/hotkeys, no typing.

Verify which instance is up:

```bash
lsof -nP -iTCP:9222 -sTCP:LISTEN   # work
lsof -nP -iTCP:9223 -sTCP:LISTEN   # personal
```

## Usage

1. Tinycast (or Raycast) → **Chrome CDP** → `work` or `personal`
2. Drive it (pin ONE port per agent, never give an agent both):
   ```bash
   agent-browser --cdp 9222 open https://example.com   # work
   agent-browser --cdp 9223 snapshot                   # personal
   ```

## Transfer profiles to another machine

Quit Chrome CDP on **both** machines first (profile files lock while running).

```bash
# export (this machine)
tar czf chrome-cdp.tar.gz -C ~/dotfiles/.local chrome-cdp chrome-cdp-personal

# copy chrome-cdp.tar.gz somehow (AirDrop, scp, …)

# import (other machine — same dotfiles layout)
mkdir -p ~/dotfiles/.local
tar xzf chrome-cdp.tar.gz -C ~/dotfiles/.local
```

Then run **Chrome CDP** on the new machine. Same logins should be there.

### Notes

- Profiles are gitignored (`.local/chrome-cdp*/`) — never commit them (cookies + tokens).
- Ports bind to localhost only. Never add `--remote-debugging-address=0.0.0.0`.
- Cookie encryption is tied to your macOS login Keychain (`Chrome Safe Storage`).
  Copying between machines under the **same macOS user / iCloud Keychain** usually
  works; a totally different Mac user may need to sign in again.
- Don't symlink these onto your main Chrome or Vivaldi profile.
