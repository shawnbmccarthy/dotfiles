vim.env.LANG = "en_US.UTF-8"
vim.env.LC_ALL = "en_US.UTF-8"

-- lua/brokenrobotz/set.lua
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.mardown_recommended_style = 0
vim.g.autoformat = true
-- providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- python provider
vim.g.python3_host_prog = "/usr/bin/python3"

vim.filetype.add({
  extension = {
    env = "dotenv",
  },
  filename = {
    [".env"] = "dotenv",
    ["env"] = "dotenv",
  },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
})
