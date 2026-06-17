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

vim.keymap.set("n", "<leader>ws", "<cmd>StripWhitespace<cr>", {
  desc = "strip trailing whitespace",
  silent = true,
})
