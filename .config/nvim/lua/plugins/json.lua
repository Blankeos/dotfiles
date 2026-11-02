return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {
          -- Use push diagnostics so the filter also works on Neovim 0.12+.
          before_init = function(params, config)
            params.capabilities.textDocument.diagnostic = nil
            config.settings.json.schemas = require("schemastore").json.schemas()
          end,
          on_init = function(client)
            client.server_capabilities.diagnosticProvider = nil
          end,
          handlers = {
            ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
              if result and result.uri then
                local bufnr = vim.uri_to_bufnr(result.uri)
                if vim.bo[bufnr].filetype == "jsonc" then
                  -- Allow trailing commas in JSONC, but keep JSON strict.
                  result.diagnostics = vim.tbl_filter(function(diagnostic)
                    return tostring(diagnostic.code) ~= "519" -- TrailingComma
                  end, result.diagnostics or {})
                end
              end
              return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            end,
          },
        },
      },
    },
  },
}
