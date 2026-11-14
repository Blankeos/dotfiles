import { parse, type ParseError } from "jsonc-parser";
import {
  copyFileSync, existsSync, mkdirSync, readdirSync, readFileSync, realpathSync,
  renameSync, statSync, unlinkSync, writeFileSync,
} from "node:fs";
import { basename, dirname, join } from "node:path";
import { HOME, die } from "./util";

export const STATE_DIR = join(process.env.XDG_STATE_HOME ?? join(HOME, ".local/state"), "mcp-sync");
const STATE_FILE = join(STATE_DIR, "state.json");

/** file (real path) -> server names we own in it */
export type State = Record<string, string[]>;
export const readState = (): State =>
  existsSync(STATE_FILE) ? JSON.parse(readFileSync(STATE_FILE, "utf8")) : {};
export const writeState = (s: State) => {
  mkdirSync(STATE_DIR, { recursive: true });
  writeFileSync(STATE_FILE, JSON.stringify(s, null, 2) + "\n");
};

export const realOrSelf = (file: string) => (existsSync(file) ? realpathSync(file) : file);

export function readJsonc(file: string): any {
  const errs: ParseError[] = [];
  const v = parse(readFileSync(file, "utf8"), errs, { allowTrailingComma: true });
  if (errs.length) die(`cannot parse ${file} (refusing to guess)`);
  return v;
}

/** Atomic write through symlinks, after backing up the previous contents (keeps the last 5). */
export function save(file: string, text: string) {
  const real = realOrSelf(file);
  mkdirSync(dirname(real), { recursive: true });
  let mode = 0o644;
  if (existsSync(real)) {
    mode = statSync(real).mode & 0o777;
    const dir = join(STATE_DIR, "backups");
    mkdirSync(dir, { recursive: true });
    copyFileSync(real, join(dir, `${basename(real)}.${Date.now()}`));
    const old = readdirSync(dir).filter((f) => f.startsWith(basename(real) + ".")).sort();
    for (const f of old.slice(0, -5)) unlinkSync(join(dir, f));
  }
  const tmp = `${real}.mcp-sync.tmp`;
  writeFileSync(tmp, text, { mode });
  renameSync(tmp, real);
}
