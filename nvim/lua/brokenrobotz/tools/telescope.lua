-- telescope setup
-- setup telescope options and extensions
-- as well as cheatsheet
local map = vim.keymap.set
local loaded = false

local function telescope()
  if not loaded then
    loaded = true
    local t = require("telescope")
    t.setup({
      defaults = {
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top" },
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
      pickers = {
        find_files = { hidden = false },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        heading = { treesitter = true },
        file_browser = {
          theme = "dropdown",
          hijack_netrw = false,
        },
      },
    })
    for _, ext in ipairs({"fzf", "fidget", "file_browser", "software_licenses", "heading"}) do
      local ok = pcall(t.load_extension, ext)
      if not ok then
        vim.notify("telescope failed to load extension " .. ext, vim.log.levels.WARN)
      end
    end
    -- load cheatsheet
    require("cheatsheet").setup({
      bundled_cheatsheets = {
        enabled = { "default", "lua", "markdown", "regex", "netrw", "unicode" },
        disabled = {},
      },
      bundled_plugin_cheatsheets = {
        enabled = { "telescope.nvim" },
        disabled = {},
      },
      include_only_installed_plugins = true,
    })
  end
  return require("telescope")
end

vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = vim.api.nvim_create_augroup("brokenrobotz-telescope", {clear = true}),
  once = true,
  callback = function() telescope() end,
})

local function pick(name)
  return function()
    telescope()
    require("telescope.builtin")[name]()
  end
end

-- mappings
map("n", "<leader>fr", pick("oldfiles"), { desc = "Telescope: recent files" })
map("n", "<leader>fb", pick("buffers"), { desc = "Telescope: file buffer" })
map("n", "<leader>fg", pick("live_grep"), { desc = "Telescope: rip grep" })
map("n", "<leader>fw", pick("grep_string"), { desc = "Telescope: grep word under cursor" })
map("n", "<leader>fh", pick("help_tags"), { desc = "Telescope: help tags" })
map("n", "<leader>fp", pick("resume"), { desc = "Telescope: resume last picker" })
map("n", "<leader>ff", pick("find_files"), { desc = "Telescope: find files" })
map("n", "<leader>fd", pick("diagnostics"), { desc = "Telescope: diagnostics" })
map("n", "<leader>fl", function()
  telescope().extensions.software_licenses.find()
end, { desc = "Telescope: select license" })
map("n", "<leader>f?", function()
  telescope()
  vim.cmd("Cheatsheet")
end, {desc = "Telescope: cheatsheet"})
map("n", "<leader>fs", pick("lsp_dynamic_workspace_symbols"), {desc = "Telescope: symbols in project"})
map("n", "<leader>fS", pick("lsp_document_symbols"), {desc = "Telescope: symbols in this file"})
map("n", "<leader>f/", pick("current_buffer_fuzzy_find"), {desc = "Telescope: search this file"})

-- git file
map("n", "<C-p>", pick("git_files"), { desc = "git: git files" })
