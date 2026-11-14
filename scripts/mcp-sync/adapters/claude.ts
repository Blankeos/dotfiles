import { planJsonMcp } from "../lib/json-mcp";
import type { Adapter, Server } from "../lib/types";
import { envToDollar, expand, mapVals } from "../lib/util";

const render = (_name: string, s: Server) => {
  if (s.enabled === false) return null; // Claude has no per-server disabled flag
  if (s.type === "remote") {
    return {
      type: "http",
      url: envToDollar(s.url!),
      ...(s.headers && { headers: mapVals(s.headers, envToDollar) }),
    };
  }
  const [command, ...args] = s.command!.map(expand);
  return {
    type: "stdio",
    command,
    args,
    ...(s.environment && { env: mapVals(s.environment, envToDollar) }),
  };
};

// ~/.claude.json also holds unrelated Claude state: we only ever touch `mcpServers`.
const adapter: Adapter = {
  name: "claude",
  paths: { global: ["~/.claude.json"], project: ".mcp.json" },
  plan: (input) => planJsonMcp({ target: "claude", input, path: () => ["mcpServers"], render }),
};

export default adapter;
