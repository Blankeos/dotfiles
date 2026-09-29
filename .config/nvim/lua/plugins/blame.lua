return {
  {
    "FabijanZulj/blame.nvim",
    cmd = "BlameToggle",
    keys = {
      { "<leader>gb", "<cmd>BlameToggle<cr>", desc = "Git blame (window)" },
      { "<leader>gB", "<cmd>BlameToggle virtual<cr>", desc = "Git blame (virtual)" },
    },
    opts = {
      date_format = "%Y-%m-%d",
      merge_consecutive = true,
      blame_options = { "-w" },
    },
  },
}
