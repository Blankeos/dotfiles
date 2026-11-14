import { homedir } from "node:os";

export const HOME = process.env.HOME ?? homedir();
export const expand = (p: string) => p.replace(/^~(?=\/|$)/, HOME);
export const tilde = (p: string) => (p.startsWith(HOME + "/") ? "~" + p.slice(HOME.length) : p);
export const isObj = (v: unknown): v is Record<string, unknown> =>
  !!v && typeof v === "object" && !Array.isArray(v);
export const mapVals = (o: Record<string, string>, f: (s: string) => string) =>
  Object.fromEntries(Object.entries(o).map(([k, v]) => [k, f(v)]));
export const die = (msg: string): never => {
  console.error(`error: ${msg}`);
  process.exit(1);
};

export const warnings: string[] = [];
export const warn = (m: string) => warnings.push(m);

/** `{env:NAME}` -> `${NAME}` (Claude-style interpolation) */
export const envToDollar = (v: string) => v.replace(/\{env:(\w+)\}/g, "${$1}");
