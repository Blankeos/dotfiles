return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Use the project-local Biome binary only when a Biome config exists.
      opts.formatters.biome = vim.tbl_deep_extend("force", opts.formatters.biome or {}, {
        require_cwd = true,
      })

      for _, ft in ipairs({
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "jsonc",
        "css",
        "graphql",
      }) do
        local fallback = opts.formatters_by_ft[ft]
        opts.formatters_by_ft[ft] = function(bufnr)
          if require("conform").get_formatter_info("biome", bufnr).available then
            return { "biome" }
          end
          -- Preserve the Prettier extra (and any other existing formatters).
          return type(fallback) == "function" and fallback(bufnr) or fallback or {}
        end
      end
    end,
  },
}
