require("cheatsheet").setup({
  bundled_cheatsheets = {
    enabled = { "default", "lua", "markdown", "regex", "netrw", "unicode" },
    disabled = {},
  },
  bundled_plugin_cheatsheets = {
    enabled = {
      "auto-session",
      "goto-preview",
      "octo.nvim",
      "telescope.nvim",
      "vim-easy-align",
      "vim-sandwich",
    },
    disabled = {},
  },
  include_only_installed_plugins = true,
})
