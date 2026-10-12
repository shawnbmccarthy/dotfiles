vim.filetype.add({
  extension = { gotmpl = "gotmpl" },
  pattern = {
    [".*/templates/.*%.tpl"] = "gotmpl",
    [".*/templates/.*%.yaml"] = "gotmpl",
  },
})

vim.lsp.config("gopls", {
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gowork", "gotmpl"},
  root_markers = {"go.work", "go.mod", ".git"},
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
