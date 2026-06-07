return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.defaults = opts.defaults or {}
      opts.defaults.mappings = opts.defaults.mappings or {}
      opts.defaults.mappings.i = opts.defaults.mappings.i or {}

      -- macOS Option navigation/editing in Telescope prompts.
      opts.defaults.mappings.i["<M-BS>"] = { "<c-s-w>", type = "command" }
      opts.defaults.mappings.i["<A-BS>"] = { "<c-s-w>", type = "command" }
      opts.defaults.mappings.i["<M-Left>"] = { "<S-Left>", type = "command" }
      opts.defaults.mappings.i["<A-Left>"] = { "<S-Left>", type = "command" }
      opts.defaults.mappings.i["<M-b>"] = { "<S-Left>", type = "command" }
      opts.defaults.mappings.i["<A-b>"] = { "<S-Left>", type = "command" }
      opts.defaults.mappings.i["<M-Right>"] = { "<S-Right>", type = "command" }
      opts.defaults.mappings.i["<A-Right>"] = { "<S-Right>", type = "command" }
      opts.defaults.mappings.i["<M-f>"] = { "<S-Right>", type = "command" }
      opts.defaults.mappings.i["<A-f>"] = { "<S-Right>", type = "command" }
    end,
  },
}
