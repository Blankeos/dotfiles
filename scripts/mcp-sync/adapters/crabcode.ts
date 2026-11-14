import { planJsonMcp } from "../lib/json-mcp";
import type { Adapter } from "../lib/types";
import { opencodeMcpPath, renderOpencodeShape } from "./opencode";

// crabcode reads the OpenCode MCP shape,
// so this adapter only differs in *where* it writes.
const adapter: Adapter = {
  name: "crabcode",
  paths: {
    global: ["~/.config/crabcode/crabcode.jsonc", "~/.config/crabcode/crabcode.json"],
    project: ".crabcode/crabcode.jsonc",
  },
  plan: (input) =>
    planJsonMcp({ target: "crabcode", input, path: opencodeMcpPath, render: renderOpencodeShape }),
};

export default adapter;
