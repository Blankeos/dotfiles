-- After mini.pairs expands `{}` on <CR>, the closing `}` is often indented like
-- the body. Align `}` with the line that opened `{` (works for nested blocks).
local function align_pair_close_brace()
  local close_row = vim.api.nvim_win_get_cursor(0)[1]
  local close_line = vim.fn.getline(close_row)
  if not close_line:find("}") then
    return
  end

  local open_indent
  for r = close_row - 1, 1, -1 do
    local line = vim.fn.getline(r)
    if line:match("%S") and line:find("{", 1, true) then
      open_indent = #(line:match("^(%s*)") or "")
      break
    end
  end
  if open_indent == nil then
    return
  end

  local close_indent = #(close_line:match("^(%s*)") or "")
  local prev = close_indent
  while close_indent > open_indent do
    vim.cmd("normal! <<")
    close_line = vim.fn.getline(close_row)
    close_indent = #(close_line:match("^(%s*)") or "")
    if close_indent >= prev then
      break
    end
    prev = close_indent
  end

  local body_row = close_row - 1
  if body_row >= 1 then
    local sw = vim.bo.shiftwidth
    local body_indent = string.rep(" ", open_indent + sw)
    vim.fn.setline(body_row, body_indent)
    vim.api.nvim_win_set_cursor(0, { body_row, #body_indent })
    vim.cmd("startinsert!")
  end
end

return {
  {
    "nvim-mini/mini.pairs",
    config = function(_, opts)
      LazyVim.mini.pairs(opts)

      local pairs = require("mini.pairs")
      if pairs._cr_dedent_brace then
        return
      end
      pairs._cr_dedent_brace = true

      _G.lazyvim_align_pair_close_brace = align_pair_close_brace

      local orig_cr = pairs.cr
      local open_line = vim.api.nvim_replace_termcodes("<C-o>O", true, true, true)
      local align_keys = vim.api.nvim_replace_termcodes(
        "<C-o>j<Cmd>lua _G.lazyvim_align_pair_close_brace()<CR>",
        true,
        true,
        true
      )

      pairs.cr = function(key)
        local res = orig_cr(key)
        if res:find(open_line, 1, true) then
          return res .. align_keys
        end
        return res
      end
    end,
  },
}