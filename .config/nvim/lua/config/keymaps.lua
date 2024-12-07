-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

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

--Switching Buffers Cmd + Option + Arrow - switches buffers
keymap.set("n", "<A-Left>", ":bprevious<CR>", opts)
keymap.set("n", "<A-Right>", ":bnext<CR>", opts)
keymap.set("n", "<A-w>", ":bd<CR>", opts)

-- Comments
keymap.set("n", "<C-/>", ":CommentToggle<CR>", opts)

-- Tabs
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
keymap.set("n", "tw", ":tabclose<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>j")
