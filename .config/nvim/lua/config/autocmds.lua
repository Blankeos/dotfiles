-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Keep Markdown editing plain/raw. LazyVim sets conceallevel=2 globally, which
-- hides link destinations, inline-code backticks, and fenced-code markers until
-- the cursor is on the line. For writing Markdown, show the actual source.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("PlainMarkdownEditing", { clear = true }),
  pattern = { "markdown", "markdown.mdx", "rmd", "quarto" },
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.opt_local.concealcursor = ""
  end,
})
