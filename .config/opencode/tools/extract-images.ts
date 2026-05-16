import { z } from "zod"
import { Database } from "bun:sqlite"
import path from "path"
import os from "os"
import fs from "fs"

const CANDIDATE_DB_PATHS = [
  path.join(os.homedir(), ".local", "share", "opencode", "opencode.db"),
  path.join(os.homedir(), "Library", "Application Support", "opencode", "opencode.db"),
]

const DB_PATH = CANDIDATE_DB_PATHS.find((p) => fs.existsSync(p)) ?? CANDIDATE_DB_PATHS[0]

const DEFAULT_OUTPUT_DIR = "/tmp/opencode-images"

function extractFromDataUrl(url: string): { mime: string; ext: string; data: Buffer } | null {
  const match = url.match(/^data:(image\/[^;]+);base64,(.+)$/s)
  if (!match) return null
  const mime = match[1]
  const ext = mime.split("/")[1]?.replace("jpeg", "jpg") ?? "png"
  const data = Buffer.from(match[2], "base64")
  return { mime, ext, data }
}

function collectImagesFromPart(part: any, images: { mime: string; ext: string; data: Buffer }[]) {
  if (part.type === "file" && part.url && part.url.startsWith("data:image")) {
    const result = extractFromDataUrl(part.url)
    if (result) images.push(result)
  }

  const attachments = part.state?.attachments ?? []
  for (const att of attachments) {
    if (att.url && att.url.startsWith("data:image")) {
      const result = extractFromDataUrl(att.url)
      if (result) images.push(result)
    }
  }
}

function queryImagesFromDB(sessionID: string): { mime: string; ext: string; data: Buffer }[] {
  const images: { mime: string; ext: string; data: Buffer }[] = []

  if (!fs.existsSync(DB_PATH)) return images

  const db = new Database(DB_PATH, { readonly: true })
  try {
    const rows = db.query("SELECT data FROM part WHERE session_id = ?").all(sessionID) as { data: string }[]
    for (const row of rows) {
      try {
        const part = JSON.parse(row.data)
        collectImagesFromPart(part, images)
      } catch {}
    }
  } finally {
    db.close()
  }

  return images
}

export default {
  description:
    "Extract all images from the current opencode session's message parts and save them as files to disk. Returns the file paths so other agents/tools can read them. Useful for non-vision models that need image analysis via a subagent.",
  args: {
    output_dir: z
      .string()
      .optional()
      .describe("Directory to save images to. Defaults to /tmp/opencode-images"),
  },
  async execute(args: { output_dir?: string }, context: { sessionID: string }) {
    const outputDir = args.output_dir || DEFAULT_OUTPUT_DIR
    const sessionID = context.sessionID

    if (!sessionID) {
      return "Error: no sessionID in context. This tool must be called from within an opencode session."
    }

    fs.mkdirSync(outputDir, { recursive: true })

    if (!fs.existsSync(DB_PATH)) {
      return `Error: opencode database not found at ${DB_PATH}`
    }

    const images = queryImagesFromDB(sessionID)

    if (images.length === 0) {
      return `No images found in session ${sessionID}. Images only exist if they were pasted or generated during this session.`
    }

    const saved: string[] = []
    for (let i = 0; i < images.length; i++) {
      const img = images[i]
      const filePath = path.join(outputDir, `${i + 1}.${img.ext}`)
      fs.writeFileSync(filePath, img.data)
      saved.push(filePath)
    }

    return [
      `Extracted ${saved.length} image(s) to ${outputDir}:`,
      ...saved.map((p, i) => `  [Image ${i + 1}] ${p}`),
      "",
      "Pass these file paths to the @vlm-agent subagent (or use the read tool) to analyze them.",
    ].join("\n")
  },
}