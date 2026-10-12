require("lualine").setup({
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      "diff",
      { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = "󰌵" } },
    },
    lualine_c = {
      {
        "filename",
        path = 1,
        file_status = true,
        newfile_status = true,
        symbols = { error = " ", warn = " ", info = " ", hint = "󰌵" },
      },
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  extensions = { "fzf", "neo-tree", "quickfix", "trouble" },
})
