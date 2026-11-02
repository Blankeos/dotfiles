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

-- Format
keymap.set("n", ",f", "<cmd>lua vim.lsp.buf.formatting()<CR>")

-- keymap.set("n", "<leader>")

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

-- Word wrap toggle (<leader>z is free; <leader>w is window prefix, <leader>uw already toggles wrap)
keymap.set("n", "<leader>z", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify((vim.wo.wrap and "Enabled" or "Disabled") .. " word wrap", vim.log.levels.INFO, { title = "Wrap" })
end, { desc = "Toggle word wrap" })

-- Replace instances in file (prefills :%s///g)
keymap.set("n", "<leader>ss", ":%s///g<Left><Left>", { desc = "Replace instances in file" })
keymap.set("v", "<leader>ss", ":s///g<Left><Left>", { desc = "Replace instances in selection" })

keymap.set("x", "I", visual_start_insert, { desc = "Insert at start of visual selection" })
keymap.set("x", "A", "<Esc>`>a", { desc = "Insert at end of visual selection" })

-- Zed-style fold levels: z1 = top level only, z2 = top + 1, etc.
for i = 1, 6 do
  keymap.set("n", "z" .. i, function()
    vim.opt.foldlevel = i
  end, { desc = "Fold to level " .. i })
end
keymap.set("n", "z0", function()
  vim.opt.foldlevel = 0
end, { desc = "Close all folds" })
keymap.set("n", "z9", function()
  vim.opt.foldlevel = 99
end, { desc = "Open all folds" })

-- Reveal current buffer in Finder (macOS `open -R`)
local function reveal_in_finder()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN, { title = "Reveal" })
    return
  end
  vim.fn.jobstart({ "open", "-R", path }, { detach = true })
end

vim.api.nvim_create_user_command("Reveal", reveal_in_finder, { desc = "Reveal current file in Finder" })
vim.api.nvim_create_user_command("RevealInFinder", reveal_in_finder, { desc = "Reveal current file in Finder" })
keymap.set("n", "<leader>fx", reveal_in_finder, { desc = "Reveal in Finder" })

-- Preview markdown in crabmd (GPUI app) — mirrors Helix `<space>m`
local function open_in_crabmd()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN, { title = "crabmd" })
    return
  end
  local pos = vim.api.nvim_win_get_cursor(0)
  local arg = string.format("%s:%d:%d", path, pos[1], pos[2] + 1)
  vim.fn.jobstart({ "crabmd", "-r", arg }, { detach = true })
end

vim.api.nvim_create_user_command("Crabmd", open_in_crabmd, { desc = "Preview current file in crabmd" })
keymap.set("n", "<leader>m", open_in_crabmd, { desc = "Preview in crabmd" })

-- Yank path menu (<leader>Y …) — mirrors Helix `space-Y`
local function copy_path(kind)
  local rel = vim.fn.expand("%")
  if rel == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN, { title = "Yank path" })
    return
  end
  local text, label
  if kind == "absolute" then
    text, label = vim.fn.expand("%:p"), "Absolute path"
  elseif kind == "filename" then
    text, label = vim.fn.expand("%:t"), "Filename"
  elseif kind == "line" then
    text, label = rel .. ":" .. vim.api.nvim_win_get_cursor(0)[1], "File:line"
  else
    text, label = rel, "Relative path"
  end
  vim.fn.setreg("+", text)
  vim.notify(text, vim.log.levels.INFO, { title = "Copied " .. label })
end

vim.api.nvim_create_user_command("CopyRelPath", function() copy_path("relative") end, { desc = "Copy relative path" })
vim.api.nvim_create_user_command("CopyAbsPath", function() copy_path("absolute") end, { desc = "Copy absolute path" })
vim.api.nvim_create_user_command("CopyFileName", function() copy_path("filename") end, { desc = "Copy filename" })
vim.api.nvim_create_user_command("CopyFileLine", function() copy_path("line") end, { desc = "Copy file:line" })
keymap.set("n", "<leader>Yp", function() copy_path("relative") end, { desc = "Yank relative path" })
keymap.set("n", "<leader>Ya", function() copy_path("absolute") end, { desc = "Yank absolute path" })
keymap.set("n", "<leader>Yn", function() copy_path("filename") end, { desc = "Yank filename" })
keymap.set("n", "<leader>Yl", function() copy_path("line") end, { desc = "Yank file:line" })

-- Cheatsheet: auto-parses THIS file, so zero maintenance — add a
-- keymap/command above and it shows up in `:Cheatsheet` / `<leader>hc`.
local function open_cheatsheet()
  local src = vim.fn.stdpath("config") .. "/lua/config/keymaps.lua"
  local ok, raw = pcall(vim.fn.readfile, src)
  if not ok then
    vim.notify("Cannot read " .. src, vim.log.levels.ERROR, { title = "Cheatsheet" })
    return
  end
  local content = table.concat(raw, "\n")
  local maps, cmds = {}, {}
  for block in content:gmatch("keymap%.set%b()") do
    local quotes = {}
    for q in block:gmatch('"([^"]+)"') do
      quotes[#quotes + 1] = q
    end
    local is_table = block:match("keymap%.set%(%s*{") ~= nil
    local modes = is_table and block:match("keymap%.set%(%s*(%b{})") or quotes[1] or "?"
    local lhs = (is_table and quotes[1] or quotes[2]) or "?"
    local desc = block:match('desc%s*=%s*"([^"]+)"') or "(no desc)"
    maps[#maps + 1] = string.format("  %-10s %-14s %s", modes, lhs, desc)
  end
  for _, line in ipairs(raw) do
    local name = line:match('nvim_create_user_command%(%s*"([^"]+)"')
    if name then
      local desc = line:match('desc%s*=%s*"([^"]+)"') or ""
      cmds[#cmds + 1] = string.format("  :%-14s %s", name, desc)
    end
  end
  table.sort(maps)
  table.sort(cmds)
  local lines = { "Custom keymaps (" .. #maps .. ")", "" }
  vim.list_extend(lines, maps)
  vim.list_extend(lines, { "", "Custom commands (" .. #cmds .. ")", "" })
  vim.list_extend(lines, cmds)
  vim.list_extend(lines, { "", "Source: lua/config/keymaps.lua (auto-parsed, q to close)" })
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "markdown"
  keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
  local w, h = math.min(72, vim.o.columns - 4), math.min(#lines + 2, vim.o.lines - 4)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = w,
    height = h,
    col = (vim.o.columns - w) / 2,
    row = (vim.o.lines - h) / 2,
    style = "minimal",
    border = "rounded",
    title = " Cheatsheet ",
    title_pos = "center",
  })
end

vim.api.nvim_create_user_command("Cheatsheet", open_cheatsheet, { desc = "Show custom keymaps + commands" })
keymap.set("n", "<leader>hc", open_cheatsheet, { desc = "Cheatsheet (custom maps)" })
