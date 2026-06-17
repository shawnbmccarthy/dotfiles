vim.lsp.config(
  "rust_ls",
  {
    cmd = {"rust-analyzer"},
    filetypes = {"rust"},
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          allTargets = true,
        },
        check = {
          command = "clippy",
          features = "all",
        },
      }
    }
  }
)

vim.lsp.enable("rust_ls")
