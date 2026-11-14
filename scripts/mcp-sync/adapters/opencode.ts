import { planJsonMcp } from "../lib/json-mcp";
import type { Adapter, Server } from "../lib/types";
import { expand, isObj } from "../lib/util";

/** Canonical shape *is* OpenCode's: just drop our own `targets` filter and expand `~`. */
export const renderOpencodeShape = (_name: string, s: Server): Record<string, unknown> => {
  const { targets: _t, ...rest } = s;
  return rest.command ? { ...rest, command: rest.command.map(expand) } : rest;
};

/** Honour OpenCode v2 `mcp.servers.<name>` when the file already uses it, else legacy `mcp.<name>`. */
export const opencodeMcpPath = (doc: any) => (isObj(doc?.mcp?.servers) ? ["mcp", "servers"] : ["mcp"]);

const adapter: Adapter = {
  name: "opencode",
  paths: {
    global: ["~/.config/opencode/opencode.jsonc", "~/.config/opencode/opencode.json"],
    project: "opencode.jsonc",
  },
  plan: (input) =>
    planJsonMcp({ target: "opencode", input, path: opencodeMcpPath, render: renderOpencodeShape }),
};

export default adapter;
