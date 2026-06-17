vim.lsp.config("qml_ls", {
  cmd = { "qmlls6" },
  filetypes = { "qml" },
  setup = {
    on_attach = function(client, bufnr)
      client.server_capabilities.semanticTokensProvider = nil
    end
  },
})

vim.lsp.enable("qml_ls")
