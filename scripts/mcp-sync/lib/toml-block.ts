import { existsSync, readFileSync } from "node:fs";
import type { Change, Plan, PlanInput, Server } from "./types";

const BEGIN = "# >>> mcp-sync: managed block, edit mcp-sync config instead >>>";
const END = "# <<< mcp-sync <<<";
const esc = (s: string) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

/** TOML-safe string / key helpers for renderers */
export const q = JSON.stringify; // a JSON string is a valid TOML basic string
export const tkey = (k: string) => (/^[\w-]+$/.test(k) ? k : q(k));
export const inlineTable = (o: Record<string, string>) =>
  `{ ${Object.entries(o).map(([k, v]) => `${tkey(k)} = ${q(v)}`).join(", ")} }`;

/**
 * Shared planner for TOML configs. We don't parse/rewrite the user's TOML (that loses comments);
 * we own one marked block at the end of the file and never touch anything outside it.
 */
export function planTomlBlock(opts: {
  target: string;
  input: PlanInput;
  /** canonical -> a complete `[mcp_servers.x]` table as text */
  render: (name: string, s: Server) => string;
}): Plan {
  const { target, input: { file, servers }, render } = opts;
  const desired: Record<string, string> = {};
  for (const [n, s] of servers) desired[n] = render(n, s);

  const text = existsSync(file) ? readFileSync(file, "utf8") : "";
  const b = text.indexOf("# >>> mcp-sync"), e = text.indexOf(END);
  const hasBlock = b >= 0 && e > b;
  const before = hasBlock ? text.slice(0, b) : text;
  const after = hasBlock ? text.slice(e + END.length).replace(/^\n/, "") : "";

  const old: Record<string, string> = {};
  if (hasBlock) {
    for (const chunk of text.slice(b + BEGIN.length, e).trim().split(/\n\n+/)) {
      const m = chunk.match(/^\[mcp_servers\.("?)([^\]".]+)\1\]/);
      if (m) old[m[2]] = chunk.trim();
    }
  }

  const changes: Change[] = [], keep: Record<string, string> = {};
  for (const [name, body] of Object.entries(desired)) {
    const clash = new RegExp(`^\\[mcp_servers\\.("?)${esc(name)}\\1[\\].]`, "m").test(before + after);
    if (clash) { changes.push({ op: "conflict", name, note: "defined by hand outside the managed block" }); continue; }
    keep[name] = body;
    if (!(name in old)) changes.push({ op: "add", name });
    else if (old[name] !== body) changes.push({ op: "update", name });
  }
  for (const name of Object.keys(old)) if (!(name in keep) && !(name in desired)) changes.push({ op: "remove", name });

  const names = Object.keys(keep);
  const block = names.length ? `${BEGIN}\n${names.map((n) => keep[n]).join("\n\n")}\n${END}\n` : "";
  const head = before.replace(/\s*$/, "");
  const next = (head ? head + (block ? "\n\n" : "\n") : "") + block + after;
  return { target, file, changes, text: next };
}
