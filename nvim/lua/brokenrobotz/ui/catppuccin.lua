-- Transparent editor (wallpaper shows through); bufferline + lualine stay opaque.
local transparent = true

require("catppuccin").setup({
  flavour = "macchiato",
  priority = 1000,
  background = {
    light = "latte",
    dark = "mocha",
  },
  transparent_background = transparent,
  float = {
    transparent = false,
    solid = false,
  },
  term_colors = false,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  no_italics = false,
  no_bold = false,
  no_underline = false,
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    miscs = {},
  },
  lsp_styles = {
    virtual_text = {
      errors = { "italic" },
      hints = { "italic" },
      warnings = { "italic" },
      information = { "italic" },
      ok = { "italic" },
    },
    underlines = {
      errors = { "underline" },
      hints = { "underline" },
      warnings = { "underline" },
      information = { "underline" },
      ok = { "underline" },
    },
    inlay_hints = { background = true },
  },
  color_overrides = {},
  custom_highlights = {},
  default_integrations = true,
  auto_integrations = true,
  integrations = {
    lualine = {
      all = function(colors)
        local mantle = { bg = colors.mantle }
        return {
          normal = { c = mantle },
          insert = { c = mantle },
          visual = { c = mantle },
          replace = { c = mantle },
          command = { c = mantle },
          terminal = { c = mantle },
          inactive = { a = mantle, b = mantle, c = mantle },
        }
      end,
    },
  },
})

vim.cmd.colorscheme("catppuccin")
