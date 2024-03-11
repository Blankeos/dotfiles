---@diagnostic disable: different-requires
local keymap = vim.keymap

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", { desc = "Jump list", noremap = true, silent = true })

-- New Tab
keymap.set("n", "te", "tabedit", { desc = "New Tab", noremap = true, silent = true })
keymap.set("n", "<tab>", ":tabnext<Return>", { desc = "Next Tab", noremap = true, silent = true })
keymap.set("n", "<leader>bb", ":b#<CR>", { desc = "Previous Tab", noremap = true, silent = true })

-- Comment
keymap.set("n", "<C-/>", "gcc", { desc = "Comment out code", noremap = true, silent = true })

-- FileTree
keymap.set("n", "<C-b>", ":Neotree toggle<CR>", { desc = "Open File Tree", noremap = true, silent = true })

-- Notifications
keymap.set("n", "<leader>nc", ":lua require('notify').dismiss()<CR>", { desc = "Clear Notifications", silent = true }) 
keymap.set("n", "<leader>nn", ":lua require('notify').history()<CR>", { desc = "Show Notifications", silent = true }) 

