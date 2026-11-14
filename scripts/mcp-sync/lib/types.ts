/** Canonical server shape (OpenCode-style) plus an optional per-server `targets` filter. */
export type Server = {
  type: "local" | "remote";
  command?: string[];
  url?: string;
  headers?: Record<string, string>;
  environment?: Record<string, string>;
  enabled?: boolean;
  targets?: string[];
  [k: string]: unknown;
};

export type Config = { targets?: string[]; mcp?: Record<string, Server> };

export type Change = { op: "add" | "update" | "remove" | "conflict"; name: string; note?: string };

/** What an adapter hands back: the new file text (if any) plus a human-readable change list. */
export type Plan = {
  target: string;
  file: string;
  changes: Change[];
  /** full new file contents */
  text?: string;
  /** server names we now own in this file (JSON adapters; TOML is self-describing via its block) */
  managed?: string[];
};

export type PlanInput = {
  /** resolved config file for the current scope (may not exist yet) */
  file: string;
  /** servers already filtered to this adapter's `targets` */
  servers: [name: string, server: Server][];
  /** names this tool wrote here last time (from the state file) */
  managed: string[];
  /** overwrite same-name servers we don't own */
  force: boolean;
};

/**
 * One agent. To support a new one: add a file in adapters/, register it in adapters/index.ts.
 * `plan` must be pure: read `input.file`, return a Plan, never write.
 */
export interface Adapter {
  name: string;
  paths: {
    /** candidates in priority order; first that exists wins, else the first one is created */
    global: string[];
    /** relative to the project root */
    project: string;
  };
  plan(input: PlanInput): Plan;
}
