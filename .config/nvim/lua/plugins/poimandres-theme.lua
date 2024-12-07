return {
  "olivercederborg/poimandres.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    disable_background = true,
    disable_float_background = true,
  },
  config = function()
    require("poimandres").setup({
      disable_background = true,
      disable_float_background = true,
    })

    vim.cmd("colorscheme poimandres")
  end,

  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "poimandres",
  --   },
  -- },
}
