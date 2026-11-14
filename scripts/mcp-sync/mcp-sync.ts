#!/usr/bin/env bun
/**
 * mcp-sync: one canonical MCP server list -> every agent's own config file.
 *
 *   mcp-sync                    plan global changes (dry run)
 *   mcp-sync --write            apply them
 *   mcp-sync -p [dir]           project scope (reads <dir>/mcp-sync.jsonc)
 *   mcp-sync --target claude    limit to some targets (comma separated)
 *   mcp-sync --force            overwrite same-name servers we don't own
 *
 * Canonical shape is OpenCode's (type local|remote, command[], url, headers,
 * environment, enabled) plus an optional per-server `targets` filter.
 * Secrets: write `{env:NAME}`; each adapter translates it.
 *
 * Layout:  adapters/<agent>.ts   one per agent, implements Adapter (lib/types.ts)
 *          adapters/index.ts     registry; add a line to support a new agent
 *          lib/                  shared planners (json-mcp, toml-block), fs, types
 *
 * Ownership: JSON adapters track the names we wrote in ~/.local/state/mcp-sync
 * so hand-added servers are never touched. TOML adapters use a marked block.
 * Edits are comment-preserving; files are written through symlinks, atomically,
 * after a backup.
 */
import { existsSync, readFileSync, realpathSync } from "node:fs";
import { basename, dirname, join, resolve } from "node:path";
import { ADAPTERS } from "./adapters";
import { readJsonc, readState, realOrSelf, save, STATE_DIR, writeState } from "./lib/fs";
import type { Config, Plan } from "./lib/types";
import { HOME, die, expand, tilde, warnings } from "./lib/util";

type Scope = { global: boolean; root: string };

function parseArgs(argv: string[]) {
  const a = { write: false, force: false, project: undefined as string | undefined, targets: undefined as string[] | undefined, help: false };
  for (let i = 0; i < argv.length; i++) {
    const x = argv[i];
    if (x === "--write" || x === "-w") a.write = true;
    else if (x === "--force") a.force = true;
    else if (x === "-h" || x === "--help") a.help = true;
    else if (x === "--target" || x === "-t") a.targets = (argv[++i] ?? "").split(",").filter(Boolean);
    else if (x === "--project" || x === "-p") a.project = argv[i + 1] && !argv[i + 1].startsWith("-") ? resolve(argv[++i]) : process.cwd();
    else die(`unknown argument ${x}`);
  }
  return a;
}

function findConfig(scope: Scope, start: string): { file: string; root: string } {
  if (scope.global) {
    const file = process.env.MCP_SYNC_CONFIG ?? join(process.env.XDG_CONFIG_HOME ?? join(HOME, ".config"), "mcp-sync/config.jsonc");
    if (!existsSync(file)) die(`no config at ${file}`);
    return { file, root: HOME };
  }
  for (let d = start; ; d = dirname(d)) {
    const f = join(d, "mcp-sync.jsonc");
    if (existsSync(f)) return { file: f, root: d };
    if (dirname(d) === d) return die(`no mcp-sync.jsonc found from ${start} upwards`);
  }
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) return console.log(readFileSync(import.meta.path, "utf8").split("*/")[0].replace(/^\/\*\*?|^ \* ?|^ \*\//gm, "").trim());

  const scope: Scope = { global: args.project === undefined, root: args.project ?? HOME };
  const { file: cfgFile, root } = findConfig(scope, args.project ?? process.cwd());
  const cfg: Config = readJsonc(cfgFile) ?? {};
  const servers = cfg.mcp ?? {};

  for (const [n, s] of Object.entries(servers)) {
    if (s.type === "local" ? !s.command?.length : s.type === "remote" ? !s.url : true)
      die(`mcp.${n}: needs type "local" + command[] or type "remote" + url`);
  }
  const names = args.targets ?? cfg.targets ?? Object.keys(ADAPTERS);
  for (const n of names) if (!ADAPTERS[n]) die(`unknown target "${n}" (known: ${Object.keys(ADAPTERS).join(", ")})`);

  console.log(`${scope.global ? "global" : "project"} config: ${tilde(cfgFile)}  (${Object.keys(servers).length} servers)\n`);
  const state = readState();
  const plans: Plan[] = [];

  for (const name of names) {
    const adapter = ADAPTERS[name];
    const candidates = scope.global ? adapter.paths.global.map(expand) : [join(root, adapter.paths.project)];
    const file = candidates.find(existsSync) ?? candidates[0];
    if (scope.global && !existsSync(file) && !existsSync(dirname(file))) {
      console.log(`${name}: skipped (${dirname(file)} not found, agent not installed?)`);
      continue;
    }
    try {
      plans.push(adapter.plan({
        file,
        servers: Object.entries(servers).filter(([, s]) => !s.targets || s.targets.includes(name)),
        managed: state[realOrSelf(file)] ?? [],
        force: args.force,
      }));
    } catch (err) {
      console.log(`${name}: ${(err as Error).message}\n`);
    }
  }

  const sym = { add: "+", update: "~", remove: "-", conflict: "!" };
  let conflicts = 0, dirty = 0;
  for (const p of plans) {
    const exists = existsSync(p.file);
    const real = exists ? realpathSync(p.file) : p.file;
    const direct = exists ? join(realpathSync(dirname(p.file)), basename(p.file)) : p.file; // show only symlinked files
    const via = !exists ? "  (new file)" : real !== direct ? `  (-> ${tilde(real)})` : "";
    console.log(`${p.target}: ${tilde(p.file)}${via}`);
    if (!p.changes.length) console.log("  up to date");
    for (const c of p.changes) {
      console.log(`  ${sym[c.op]} ${c.name}${c.note ? `  [${c.note}]` : ""}`);
      if (c.op === "conflict") conflicts++;
    }
    if (p.changes.some((c) => c.op !== "conflict")) dirty++;
    console.log();
  }
  for (const w of warnings) console.log(`warning: ${w}`);

  if (!args.write) {
    if (dirty) console.log("dry run. re-run with --write to apply.");
  } else {
    const next = readState();
    for (const p of plans) {
      if (p.changes.some((c) => c.op !== "conflict") && p.text !== undefined) save(p.file, p.text);
      if (p.managed) next[realOrSelf(p.file)] = p.managed;
    }
    writeState(next);
    console.log(dirty ? `applied to ${dirty} file(s). backups in ${join(STATE_DIR, "backups")}` : "nothing to write.");
  }
  if (conflicts) process.exitCode = 2;
}

main();
