import type { Adapter } from "../lib/types";
import claude from "./claude";
import codex from "./codex";
import crabcode from "./crabcode";
import opencode from "./opencode";

// Register a new agent here (one line) after adding adapters/<name>.ts.
export const ADAPTERS: Record<string, Adapter> = Object.fromEntries(
  [opencode, crabcode, claude, codex].map((a) => [a.name, a]),
);
