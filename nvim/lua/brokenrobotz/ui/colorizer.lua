vim.api.nvim_create_autocmd({"BufReadPre", "BufNewFile"}, {
  group = vim.api.nvim_create_augroup("brokenrobotz-colorizer", {clear =true}),
  once = true,
  callback = function()
    require("colorizer").setup({
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
    })
  end
})
