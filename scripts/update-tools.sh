#!/usr/bin/env bash

# Update all tools in parallel with a TUI.
# Edit mprocs.yaml (next to this script) to add or remove tools.
# cd here so mprocs's hardcoded panic log (mprocs.log) lands on the
# symlink-to-/dev/null we keep in this dir, instead of the user's cwd.
cd "$(dirname "$0")" || exit 1
mprocs --config ./mprocs.yaml
