vim.lsp.config("gopls", {
  settings = {
    gopls = {
      staticcheck = true,
      gofumpt = true,
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        shadow = true,
        unusedparams = true,
        unusedvariables = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

vim.lsp.enable("gopls")
