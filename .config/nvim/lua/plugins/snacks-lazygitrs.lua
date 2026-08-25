return {
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = {
        configure = false, -- snacks assumes real lazygit YAML/theme
      },
    },
    keys = {
      {
        "<leader>gg",
        function()
          Snacks.terminal({ "lazygitrs" }, {
            cwd = LazyVim.root.git(),
            win = { style = "lazygit" },
          })
        end,
        desc = "Lazygitrs",
      },
    },
  },
}
