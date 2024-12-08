return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = { position = "right" },
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    follow_current_file = {
      enabled = false,
    },
    use_libuv_file_water = true,
  },
}
