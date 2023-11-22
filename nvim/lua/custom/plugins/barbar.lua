return {
 {
   'romgrk/barbar.nvim',
   dependencies = {
     'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
     'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
   },
   config = function() vim.g.barbar_auto_setup = false end,
   -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
   -- animation = true,
   -- insert_at_start = true,
   -- …etc.
 },
}
