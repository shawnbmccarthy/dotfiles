vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyrightconfig.json",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
  settings = {
    pyright = {
      -- use ruff import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        ignore = { "*" },
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "basic",
      },
    },
  },
})

vim.lsp.config("ruff", {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  init_options = {
    settings = {
      configurationPreference = "filesystemFirst",
      lineLength = 100,
      organizeImports = true,
      configuration = {
        lint = {
          unfixable = { "F401" },
          ["extend-select"] = { "TID251" },
          ["flake8-tidy-imports"] = {
            ["banned-api"] = {
              ["typing.TypedDict"] = {
                msg = "Use `typing_extensions.TypedDict` instead"
              },
            },
          },
        },
        format = {
          backend = "uv",
          ["quote-styple"] = "double",
        },
      },
    },
  }
})

vim.lsp.enable("pyright")
vim.lsp.enable("ruff")

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("python_ft", { clear = true }),
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})
