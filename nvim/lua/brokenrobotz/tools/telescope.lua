require("telescope").setup({
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
    find_files = { hidden = true },
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
      theme = "ivy",
      hijack_netrw = true,
    },
  },
})

local map = vim.keymap.set
local telescope = require("telescope")
local builtin = require("telescope.builtin")

local ok, err = pcall(telescope.load_extension, "fzf")
if not ok then
  vim.notify("telescope-fzf-native not built: " .. err, vim.log.levels.WARN)
end
telescope.load_extension("file_browser")
telescope.load_extension("software_licenses")
telescope.load_extension("heading")

map("n", "<leader>fr", builtin.oldfiles, { desc = "files: recent" })
map("n", "<leader>fb", builtin.buffers, { desc = "files: buffer" })
map("n", "<leader>sg", builtin.live_grep, { desc = "search: grep (ripgrep)" })
map("n", "<leader>sw", builtin.grep_string, { desc = "search word under cursor" })
map("n", "<leader>sh", builtin.help_tags, { desc = "search: help tags" })
map("n", "<leader>sr", builtin.resume, { desc = "search: resume last picker" })
map("n", "<C-p>", builtin.git_files, { desc = "git: git files" })

map("n", "<leader>ff", function()
  builtin.find_files({ hidden = true })
end, { desc = "files: find" })

map("n", "<leader>sl", function()
  require("telescope").extensions.software_licenses.find()
end, { desc = "insert license" })

map("n", "<leader>f.", function()
  require("telescope").extensions.file_browser.file_browser({
    path = vim.fn.expand("%:p:h"),
    hidden = true,
    respect_gitignore = false,
  })
end, { desc = "files: file browser (cwd=file dir)" })
