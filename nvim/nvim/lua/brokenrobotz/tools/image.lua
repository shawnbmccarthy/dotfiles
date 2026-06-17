require("image").setup({
  backend = "kitty",
  max_width = 60,
  max_height = 40,
  max_width_window_percentage = 0.5,
  window_overlap_clear_enabled = true,
  window_overlap_clear_ft_ignore = { "neo-tree", "TelescopePrompt", "cmp_menu", "cmp_docs" },
  filesystem = {
    window = {
      mappings = {["P"] = { "toggle_preview", config = { use_float = true } } },
    },
  },
})
