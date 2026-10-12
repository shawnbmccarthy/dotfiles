vim.lsp.config("vtsls", {
  cmd = {"vtsls", "--stdio"},
  filetypes = {"javascript", "javascriptreact", "typescript", "typescriptreact"},
  root_markers = {"tsconfig.json", "jsconfig.json", "package.json", ".git"},
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
    }
  },
})

vim.lsp.enable("vtsls")
