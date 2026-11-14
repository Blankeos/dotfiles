import { applyEdits, modify, parse, type ParseError } from "jsonc-parser";
import { existsSync, readFileSync } from "node:fs";
import { isDeepStrictEqual } from "node:util";
import type { Change, Plan, PlanInput, Server } from "./types";
import { isObj } from "./util";

/**
 * Shared planner for adapters whose MCP list is a JSON/JSONC object keyed by server name.
 * Comment-preserving edits; only touches keys we own (or add), never hand-written ones.
 */
export function planJsonMcp(opts: {
  target: string;
  input: PlanInput;
  /** where the server map lives in the document (default: ["mcp"]) */
  path?: (doc: any) => string[];
  /** canonical -> native entry; return null to skip this server for this agent */
  render: (name: string, s: Server) => unknown | null;
}): Plan {
  const { target, input: { file, servers, managed: managedBefore, force }, render } = opts;

  const desired: Record<string, unknown> = {};
  for (const [n, s] of servers) {
    const r = render(n, s);
    if (r !== null) desired[n] = r;
  }

  let text = existsSync(file) ? readFileSync(file, "utf8") : "{}\n";
  const errs: ParseError[] = [];
  const doc = parse(text, errs, { allowTrailingComma: true }) ?? {};
  if (errs.length) throw new Error(`cannot parse ${file} (refusing to guess)`);
  const path = (opts.path ?? (() => ["mcp"]))(doc);
  const section = path.reduce((o: any, k) => o?.[k], doc) ?? {};
  if (!isObj(section)) throw new Error(`${path.join(".")} in ${file} is not an object`);

  const changes: Change[] = [];
  const managed = new Set<string>();
  const edit = (name: string, value: unknown) => {
    text = applyEdits(text, modify(text, [...path, name], value, {
      formattingOptions: { insertSpaces: true, tabSize: 2, eol: "\n" },
    }));
  };

  for (const [name, value] of Object.entries(desired)) {
    const has = name in section, mine = managedBefore.includes(name);
    if (has && isDeepStrictEqual(section[name], value)) { managed.add(name); continue; }
    if (has && !mine && !force) { changes.push({ op: "conflict", name, note: "exists, not managed (use --force)" }); continue; }
    edit(name, value);
    managed.add(name);
    changes.push({ op: has ? "update" : "add", name });
  }
  for (const name of managedBefore) {
    if (name in desired) continue;
    if (name in section) { edit(name, undefined); changes.push({ op: "remove", name }); }
  }
  return { target, file, changes, text, managed: [...managed] };
}
