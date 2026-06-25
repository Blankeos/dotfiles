return {
  {
    "nvim-mini/mini.surround",
    keys = {
      { "ys", desc = "Add surrounding", mode = { "n", "x" } },
      { "ds", desc = "Delete surrounding" },
      { "cs", desc = "Change surrounding" },
      { "S", desc = "Add surrounding", mode = "x" },
      { "yss", desc = "Add surrounding to line" },
    },
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
        suffix_last = "",
        suffix_next = "",
      },
      search_method = "cover_or_next",
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)

      -- Visual-mode vim-surround muscle memory: select text, then S<char>.
      pcall(vim.keymap.del, "x", "ys")
      vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add("visual")<CR>]], { desc = "Add surrounding", silent = true })
      vim.keymap.set("n", "yss", "ys_", { desc = "Add surrounding to line", remap = true })
    end,
  },
}
