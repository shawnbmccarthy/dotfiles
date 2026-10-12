vim.lsp.config(
  "rust_ls",
  {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = {"Cargo.toml", ".git"},
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
        diagnostics = {
          enable = true,
          refreshSupport = false,
        }
      }
    }
  }
)

vim.lsp.enable("rust_ls")
