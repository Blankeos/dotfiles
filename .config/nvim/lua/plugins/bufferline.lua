return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      local active_bg = "#23252b"
      local inactive_bg = "NONE"
      local muted = "#767c9d"
      local text = "#a6accd"
      local strong = "#e4f0fb"
      local border = "#202022"
      local primary = "#60a5fa"

      opts.highlights = vim.tbl_deep_extend("force", opts.highlights or {}, {
        fill = { bg = inactive_bg },
        background = { fg = muted, bg = inactive_bg },
        buffer = { fg = muted, bg = inactive_bg },
        buffer_visible = { fg = text, bg = inactive_bg },
        buffer_selected = { fg = strong, bg = active_bg, bold = true, italic = true },
        numbers = { fg = muted, bg = inactive_bg },
        numbers_visible = { fg = text, bg = inactive_bg },
        numbers_selected = { fg = primary, bg = active_bg, bold = true },
        close_button = { fg = muted, bg = inactive_bg },
        close_button_visible = { fg = text, bg = inactive_bg },
        close_button_selected = { fg = text, bg = active_bg },
        modified = { fg = primary, bg = inactive_bg },
        modified_visible = { fg = primary, bg = inactive_bg },
        modified_selected = { fg = primary, bg = active_bg },
        duplicate = { fg = muted, bg = inactive_bg, italic = true },
        duplicate_visible = { fg = muted, bg = inactive_bg, italic = true },
        duplicate_selected = { fg = muted, bg = active_bg, italic = true },
        separator = { fg = border, bg = inactive_bg },
        separator_visible = { fg = border, bg = inactive_bg },
        separator_selected = { fg = primary, bg = active_bg },
        indicator_selected = { fg = primary, bg = active_bg },
        tab = { fg = muted, bg = inactive_bg },
        tab_selected = { fg = strong, bg = active_bg, bold = true },
        tab_separator = { fg = border, bg = inactive_bg },
        tab_separator_selected = { fg = primary, bg = active_bg },
      })

      local function patch_selected_devicons()
        for _, group in ipairs(vim.fn.getcompletion("BufferLineDevIcon", "highlight")) do
          if group:find("Selected$") then
            local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
            hl.bg = tonumber(active_bg:sub(2), 16)
            hl.italic = false
            hl.bold = false
            vim.api.nvim_set_hl(0, group, hl)
          end
        end
      end

      vim.api.nvim_create_autocmd({ "ColorScheme", "BufEnter", "TabEnter" }, {
        group = vim.api.nvim_create_augroup("BlankeosBufferlineDevicons", { clear = true }),
        callback = function()
          vim.schedule(patch_selected_devicons)
        end,
      })
    end,
  },
}
