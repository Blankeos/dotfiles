# Chrome CDP

Raycast script that launches a dedicated Chrome instance with remote debugging
for `agent-browser`.

## Paths

| What | Where |
|---|---|
| Script | `~/.config/raycast/scripts/chrome-cdp.sh` (via dotfiles) |
| Profile (persistent, gitignored) | `~/dotfiles/.local/chrome-cdp` |
| CDP port | `9222` |

Sign into sites once in that Chrome window — cookies/logins stick in the
profile dir across launches and machines (when you copy it).

## Usage

1. Raycast → **Chrome CDP**
2. Drive it:
   ```bash
   agent-browser connect 9222
   agent-browser --cdp 9222 open https://example.com
   agent-browser --cdp 9222 snapshot
   ```

## Transfer profile to another machine

Quit Chrome CDP on **both** machines first (profile files lock while running).

```bash
# export (this machine)
tar czf chrome-cdp.tar.gz -C ~/dotfiles/.local chrome-cdp

# copy chrome-cdp.tar.gz somehow (AirDrop, scp, …)

# import (other machine — same dotfiles layout)
mkdir -p ~/dotfiles/.local
tar xzf chrome-cdp.tar.gz -C ~/dotfiles/.local
```

Then run **Chrome CDP** on the new machine. Same logins should be there.

### Notes

- Profile is gitignored (`.local/chrome-cdp/`) — never commit it (cookies + tokens).
- Cookie encryption is tied to your macOS login Keychain (`Chrome Safe Storage`).
  Copying between machines under the **same macOS user / iCloud Keychain** usually
  works; a totally different Mac user may need to sign in again.
- Don't symlink this onto your main Chrome or Vivaldi profile.
