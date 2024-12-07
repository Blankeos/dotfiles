return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<A-a>",
        clear_suggestion = "A-c>",
      },
    })
  end,
}
