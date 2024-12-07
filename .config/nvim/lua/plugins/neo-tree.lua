return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = { position = "right" },
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
  },
}
