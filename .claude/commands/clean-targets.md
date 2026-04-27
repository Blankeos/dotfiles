---
model: claude-haiku-4-5-20251001
---

Scan for dev projects under a path and help me decide which build/dependency artifacts to clean. Conversational — I want to talk through the shortlist before anything is deleted.

## Hard rules — do not violate

1. **Never delete anything yourself.** Do not call `rm`, `rm -rf`, `trash`, `find -delete`, `git clean`, `cargo clean`, `npm`/`pnpm` cache prune, or any other destructive command. Ever.
2. **Only print commands** I can copy-paste and run myself. Treat every `rm -rf` you might have considered as a *string of text to display*, not a command to execute.
3. **Always summarize first, then wait.** Present the findings and a proposed shortlist, and stop. Do not emit commands until I've confirmed — I may want to narrow the list, exclude specific projects, or change the filter.
4. If I ask you to "just delete them," **refuse and print the commands instead.** This is non-negotiable.

## What I want to be able to ask

Natural-language filters. Examples:

- "rust projects older than 6 months"
- "node projects over 500MB that I haven't touched this year"
- "everything in ~/code/experiments except the one called realtime-demo"
- "only show me ones where the artifacts are more than 90% of the total size"

Parse `$ARGUMENTS` as a mix of: paths to scan (default: cwd), project-type filters, size filters, age filters, and name includes/excludes. If intent is ambiguous, ask me one clarifying question before scanning.

## Project types to detect

Project root = directory containing the marker; artifact dirs are what gets reclaimed.

| Type | Marker | Artifact dirs |
|---|---|---|
| Cargo (Rust) | `Cargo.toml` | `target` |
| Node | `package.json` | `node_modules`, `.next`, `dist`, `build`, `.turbo`, `.svelte-kit`, `.nuxt`, `.cache` |
| Turborepo | `turbo.json` | `.turbo`, `node_modules` |
| CMake | `CMakeLists.txt` | `build` |
| Composer (PHP) | `composer.json` | `vendor` |
| Elixir | `mix.exs` | `_build`, `deps` |
| Gradle | `build.gradle`, `build.gradle.kts` | `build`, `.gradle` |
| Maven | `pom.xml` | `target` |
| Jupyter | `*.ipynb` | `.ipynb_checkpoints` |
| Pixi | `pixi.toml` | `.pixi` |
| Python | `setup.py`, `pyproject.toml`, `requirements.txt` | `__pycache__`, `.venv`, `venv`, `.pytest_cache`, `.mypy_cache`, `.ruff_cache`, `build`, `dist`, `*.egg-info` |
| Pub (Dart) | `pubspec.yaml` | `.dart_tool`, `build` |
| SBT (Scala) | `build.sbt` | `target`, `project/target` |
| Stack | `stack.yaml` | `.stack-work` |
| Cabal | `*.cabal` | `dist-newstyle`, `dist` |
| Swift | `Package.swift` | `.build` |
| Unity | `Assets/` + `ProjectSettings/` | `Library`, `Temp`, `Obj`, `Build`, `Logs` |
| Unreal | `*.uproject` | `Binaries`, `Build`, `Intermediate`, `Saved`, `DerivedDataCache` |
| Godot | `project.godot` | `.godot`, `.import` |
| Zig | `build.zig` | `zig-cache`, `zig-out` |
| .NET | `*.sln`, `*.csproj`, `*.fsproj` | `bin`, `obj` |
| Terraform | `*.tf` | `.terraform` |
| React Native | `package.json` + `ios/` or `android/` | `ios/Pods`, `ios/build`, `android/build`, `android/.gradle`, `android/app/build` |

## How to scan

1. Walk each input path. Skip descending into any artifact dir, `.git`, and symlinks. Prefer `fd` if available; fall back to `find`.
2. Don't redetect nested same-type projects (a `package.json` inside `node_modules` isn't a new project). Nested *different*-type projects are fine.
3. Per project compute:
   - **Reclaimable** — `du -sk` summed across present artifact dirs.
   - **Total** — `du -sk` of the whole project.
   - **Last modified** — most recent mtime of source files, excluding artifact dirs and `.git`. macOS: `stat -f %m`.
4. Apply the parsed filters.
5. Sort by reclaimable size, descending.

## Output — two phases

### Phase 1: summary (always)

Show a single table, then stop and wait for my response.

```
Project                        Type     Reclaimable   Total    Last modified
~/code/foo                     Cargo    1.2 GB        1.3 GB   3 days ago (2026-04-20)
~/code/bar                     Node     480 MB        492 MB   5 mo ago  (2025-11-14)
...

Total reclaimable: X GB across N projects (filter: <what you applied>)
```

Then a short recommendation in prose — e.g. "Top 3 by reclaimable size; the bottom 2 were touched last week so maybe skip those." End with: **"Tell me which to include/exclude, or say 'print commands' to get the shell snippet."**

### Phase 2: commands (only when I confirm)

Print a copy-pasteable block. Group by project, comment each with size and last-modified:

```sh
# ~/code/foo (Cargo) — reclaims 1.2 GB, last modified 3 days ago
rm -rf ~/code/foo/target

# ~/code/bar (Node) — reclaims 480 MB, last modified 5 months ago
rm -rf ~/code/bar/node_modules ~/code/bar/.next
```

Use `~` for `$HOME`. Quote paths that contain spaces. Don't wrap in a script — a plain list is easier to edit before running.

If no projects match, say so plainly and suggest a looser filter.
