import { inlineTable, planTomlBlock, q, tkey } from "../lib/toml-block";
import type { Adapter, Server } from "../lib/types";
import { expand, warn } from "../lib/util";

const render = (name: string, s: Server): string => {
  const L = [`[mcp_servers.${tkey(name)}]`];
  if (s.enabled === false) L.push("enabled = false");
  const leftover = (v: string) => v.includes("{env:") && warn(`codex/${name}: unresolved {env:...} in "${v}"`);

  if (s.type === "remote") {
    L.push(`url = ${q(s.url)}`);
    const http: Record<string, string> = {}, fromEnv: Record<string, string> = {};
    for (const [h, v] of Object.entries(s.headers ?? {})) {
      const bearer = v.match(/^Bearer \{env:(\w+)\}$/), env = v.match(/^\{env:(\w+)\}$/);
      if (h.toLowerCase() === "authorization" && bearer) L.push(`bearer_token_env_var = ${q(bearer[1])}`);
      else if (env) fromEnv[h] = env[1];
      else (leftover(v), (http[h] = v));
    }
    if (Object.keys(http).length) L.push(`http_headers = ${inlineTable(http)}`);
    if (Object.keys(fromEnv).length) L.push(`env_http_headers = ${inlineTable(fromEnv)}`);
  } else {
    const [command, ...args] = s.command!.map(expand);
    L.push(`command = ${q(command)}`, `args = [${args.map((a) => q(a)).join(", ")}]`);
    const env: Record<string, string> = {}, vars: string[] = [];
    for (const [k, v] of Object.entries(s.environment ?? {})) {
      const m = v.match(/^\{env:(\w+)\}$/);
      if (m && m[1] === k) vars.push(k);
      else (leftover(v), (env[k] = v));
    }
    if (vars.length) L.push(`env_vars = [${vars.map((a) => q(a)).join(", ")}]`);
    if (Object.keys(env).length) L.push(`env = ${inlineTable(env)}`);
  }
  return L.join("\n");
};

const adapter: Adapter = {
  name: "codex",
  paths: { global: ["~/.codex/config.toml"], project: ".codex/config.toml" },
  plan: (input) => planTomlBlock({ target: "codex", input, render }),
};

export default adapter;
