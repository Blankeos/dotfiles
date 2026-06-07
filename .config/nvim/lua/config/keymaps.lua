-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Important Accessibility: macOS Option navigation/editing in insert/cmdline prompts.
keymap.set({ "i", "c" }, "<M-BS>", "<C-w>", opts)
keymap.set({ "i", "c" }, "<A-BS>", "<C-w>", opts)
keymap.set({ "i", "c" }, "<M-Left>", "<S-Left>", opts)
keymap.set({ "i", "c" }, "<A-Left>", "<S-Left>", opts)
keymap.set({ "i", "c" }, "<M-b>", "<S-Left>", opts)
keymap.set({ "i", "c" }, "<A-b>", "<S-Left>", opts)
keymap.set({ "i", "c" }, "<M-Right>", "<S-Right>", opts)
keymap.set({ "i", "c" }, "<A-Right>", "<S-Right>", opts)
keymap.set({ "i", "c" }, "<M-f>", "<S-Right>", opts)
keymap.set({ "i", "c" }, "<A-f>", "<S-Right>", opts)

keymap.set("n", "x", '"_x') -- Don't store in clipboard when removing char

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save file and quit
-- keymap.set("n", "<Leader>w", ":update<Return>", opts)
-- keymap.set("n", "<Leader>q", ":quit<Return>", opts)
-- keymap.set("n", "<Leader>Q", ":qa<Return>", opts)

-- Comments
keymap.set("n", "<C-/>", ":CommentToggle<CR>", opts)

-- Tabs
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
keymap.set("n", "tw", ":tabclose<Return>", opts)

-- Split window
keymap.set("n", "sd", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>wd", "<C-w>s", { desc = "Split window down" })
keymap.set("n", "<leader>wx", "<C-w>c", { desc = "Delete window split" })

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>j")

-- Format
keymap.set("n", ",f", "<cmd>lua vim.lsp.buf.formatting()<CR>")

-- Accessibility: Better Shift A and I in visual mode (Like in Zed)
local function visual_selection_pos(mark)
  local pos = vim.fn.getpos(mark)
  local line = pos[2]
  local col = pos[3]
  local line_len = #vim.fn.getline(line)

  col = math.max(1, math.min(col, math.max(line_len, 1)))
  return { line, col - 1 }
end

local function visual_start_insert()
  vim.cmd("normal! \27")
  vim.api.nvim_win_set_cursor(0, visual_selection_pos("'<"))
  vim.cmd("startinsert")
end

keymap.set("x", "I", visual_start_insert, { desc = "Insert at start of visual selection" })
keymap.set("x", "A", "<Esc>`>a", { desc = "Insert at end of visual selection" })
