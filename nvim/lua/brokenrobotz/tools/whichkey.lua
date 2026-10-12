local wk = require("which-key")

wk.setup({
  plugins = { spelling = true },
  win = { border = "rounded" },
  layout = { spacing = 6 },
})

wk.add({
  { "<leader>f", group = "telescope" },
  { "<leader>w", group = "window" },
  { "<leader>b", group = "buffer" },
  { "<leader>c", group = "code / lsp" },
  { "<leader>u", group = "ui" },
  { "<leader>x", group = "lists (quickfix/loclist)" },
  { "<leader><tab>", group = "tabs" },
  { "<leader>t", group = "toggle" },
  { "<leader>d", group = "debug" },
})
