require("colorizer").setup({
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      names = true,
      RRGGBBAA = false,
      rgb_fn = false,
      hsl_fn = false,
      css = false,
      css_fn = false,
      mode = "virtualtext",
    },
  },
})
