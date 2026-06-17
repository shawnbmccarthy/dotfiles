local harpoon = require("harpoon")
harpoon:setup({})

-- telescope
local conf = require("telescope.config").values

local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.values)
  end

  require("telescope.pickers").new({},{
    prompt_title = "harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end

vim.keymap.set("n", "<C-s>", function() toggle_telescope(harpoon:list()) end, { desc = "open harpoon" })
