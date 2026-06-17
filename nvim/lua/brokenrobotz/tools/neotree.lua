require("neo-tree").setup({
  close_if_last_window = false,
  window = { width = 32 },
  filesystem = {
    filtered_items = { hide_dotfiles = false, hide_gitignored = false },
    follow_current_file = { enabled = true },
  },
  default_component_configs = {
    indent = { with_expanders = true },
    diagnostics = { symbols = { hint = "", info = " ", warn = "", error = " " } },
    git_status = { symbols = { added = " ", modified = " ", deleted = " ", renamed = " " } },
  },
})
