require("neo-tree").setup({
  sources = {
    "filesystem",
    "buffers",
    "git_status",
    "document_symbols"
  },
  auto_clean_after_session_restore = false,
  add_blank_line_at_top = false,
  clipboard = { sync = "universal" },
  close_if_last_window = true,
  default_source = "filesystem",
  enable_cursor_hijack = false,
  enable_diagnostics = true,
  enable_git_status = true,
  enable_modified_markers = true,
  enable_refresh_on_write = true,
  filesystem = {
    hijack_netrw_behavior = "open_current",
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_pattern = { "*.class" },
    },
    follow_current_file = { enabled = true },
  },
  git_status_async = true,
  git_status_async_options = {
    -- large repo options
    batch_size = 1000,
    batch_delay = 10,
    max_lines = 10000,
  },
  git_status_scope_to_path = true,
  hide_root_node = false,
  keep_altfile = false,
  log_level = vim.log.levels.WARN,
  log_to_file = false,
  open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" }, -- when opening files, do not use windows containing these filetypes or buftypes
  open_files_in_last_window = true,
  open_files_using_relative_paths = false,
  popup_border_style = "NC",
  retain_hidden_root_indent = false,
  resize_timer_interval = 500,
  sort_case_insensitive = false,
  sort_function = nil,
  trash = {
    command = nil,
  },
  use_default_mappings = true,
  use_popups_for_input = true,
  window = {
    width = 32,
    mappings = {
      ["<space>"] = "none",
    },
  },
})

local map = vim.keymap.set

-- mappings
map("n", "<leader>e", "<cmd>Neotree toggle reveal left<cr>", { desc = "Neotree: toggle view" })

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("brokenrobotz-buffer-cleanup", {clear = true}),
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= "" or vim.api.nvim_buf_get_name(ev.buf) == "" then
      return
    end
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if b ~= ev.buf
        and vim.bo[b].buflisted
        and vim.bo[b].buftype == ""
        and not vim.bo[b].modified
        and vim.fn.bufwinid(b) == -1 then
        local name = vim.api.nvim_buf_get_name(b)
        local empty = name == ""
          and vim.api.nvim_buf_line_count(b) == 1
          and vim.api.nvim_buf_get_lines(b, 0, 1, false)[1] == ""
        if empty or vim.fn.isdirectory(name) == 1 then
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(b) then
              pcall(vim.api.nvim_buf_delete, b, {})
            end
          end)
        end
      end
    end
  end,
})
