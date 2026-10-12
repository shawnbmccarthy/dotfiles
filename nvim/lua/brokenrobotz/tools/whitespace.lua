-- vim-better-whitespace (see plugins.lua)
vim.g.better_whitespace_enabled = 1
vim.g.strip_whitespace_on_save = 1
vim.g.strip_whitespace_confirm = 0
vim.g.better_whitespace_filetypes_blacklist = {
  "diff",
  "gitcommit",
  "unite",
  "qf",
  "help",
  "markdown",
}

-- set keymap to sit in the code/lsp space
vim.keymap.set("n", "<leader>cs", "<cmd>StripWhitespace<cr>", {
  desc = "strip trailing whitespace",
  silent = true,
})
