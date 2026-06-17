require("lualine").setup({
  options = {
    theme = "catppuccin-nvim",
    icons_enabled = true,
    global_status = true,
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
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
  extensions = { "fzf", "lazy", "mason", "neo-tree", "quickfix", "trouble" },
})
