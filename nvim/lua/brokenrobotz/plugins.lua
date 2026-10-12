vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("brokenrobotz-pack-build", {clear = true}),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end
    if name == "telescope-fzf-native.nvim" then
      local res = vim.system({"make"}, {cwd = ev.data.path}):wait()
      if res.code ~= 0 then
        vim.notify("fzf-native build failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
      end
    elseif name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  "https://github.com/stevearc/aerial.nvim",
  "https://github.com/catppuccin/nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/catgoose/nvim-colorizer.lua",
  "https://github.com/akinsho/bufferline.nvim",
  -- required by neotree & telescope
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope-file-browser.nvim",
  "https://github.com/chip/telescope-software-licenses.nvim",
  "https://github.com/crispgm/telescope-heading.nvim",
  "https://github.com/folke/trouble.nvim",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/3rd/image.nvim",
  -- required by neotree
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/ntpeters/vim-better-whitespace",
  "https://github.com/doctorfree/cheatsheet.nvim",
  {
    src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
    version = vim.version.range("3"),
  },
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/mfussenegger/nvim-jdtls",
})
