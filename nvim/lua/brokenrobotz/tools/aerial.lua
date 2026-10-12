require("aerial").setup({
  backends = { "lsp", "treesitter", "markdown", "man" },
  layout = {
    default_direction = "right",
    min_width = 30,
  },
  show_guides = true,
})

vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle! right<cr>", {desc = "outline (aerial)"})
