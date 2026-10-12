local palette = require("catppuccin.palettes").get_palette()
local groups = require("bufferline.groups")

local inactive = palette.mantle
local active = palette.base
local crust = palette.crust

local function opaque(bg, extra)
  return vim.tbl_extend("force", {bg = bg}, extra or {})
end

local opaque_highlights = {
  fill = opaque(crust),
  background = opaque(inactive),
  buffer_visible = {fg = palette.surface1, bg = inactive },
  buffer_selected = {fg = palette.text, bg = active},
  duplicate = {fg = palette.surface1, bg = inactive},
  duplicate_visible = {fg = palette.surface1, bg = inactive},
  duplicate_selected = {fg = palette.text, bg = active},
  tab = {fg = palette.surface1, bg = inactive},
  tab_selected = {fg = palette.sky, bg = active, bold = true},
  tab_separator = {fg = crust, bg = inactive },
  tab_separator_selected = {fg = crust, bg = active },
  tab_close = {fg = palette.red, bg = inactive },
  separator = {fg = crust, bg = inactive },
  separator_visible = {  fg = crust, bg = inactive },
  separator_selected = { fg = crust, bg = active },
  offset_separator = {fg = crust, bg = active },
  close_button = { fg = palette.surface1, bg = inactive },
  close_button_visible = {fg = palette.surface1, bg = inactive },
  close_button_selected = {fg = palette.red, bg = active },
  indicator_visible = { fg = palette.peach, bg = inactive },
  indicator_selected = { fg = palette.peach, bg = active },
  numbers = { fg = palette.subtext0, bg = inactive },
  numbers_visible = {fg = palette.subtext0, bg = inactive},
  numbers_selected = {fg = palette.subtext0, bg = active },
  modified = {fg = palette.peach, bg = inactive },
  modified_visible = {fg = palette.peach, bg = inactive },
  modified_selected = {fg = palette.peach, bg = active },
}

for _, kind in ipairs({"error", "warning", "info", "hint"}) do
  local fg = palette[kind]
  opaque_highlights[kind] = {fg = fg, bg = inactive }
  opaque_highlights[kind .. "_visible"] = {fg = fg, bg = inactive }
  opaque_highlights[kind .. "_selected"] = {fg = fg, bg = active }
  opaque_highlights[kind .. "_diagnostic"] = {fg = fg, bg = inactive }
  opaque_highlights[kind .. "_diagnostic_visible"] = {fg = fg, bg = inactive }
  opaque_highlights[kind .. "_diagnostic_selected"] = {fg = fg, bg = active }
end

opaque_highlights.diagnostic = {fg = palette.subtext0, bg = inactive }
opaque_highlights.diagnostic_visible = {fg = palette.subtext0, bg = inactive }
opaque_highlights.diagnostic_selected = {fg = palette.subtext0, bg = active }

require("bufferline").setup({
  options = {
    mode = "buffers",
    numbers = "none",
    diagnostics = "nvim_lsp",
    separator_style = "slant",
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = false,
    always_show_bufferline = true,
    color_icons = true,
    name_formatter = function(buf)
      return vim.fn.fnamemodify(buf.name, ":t")
    end,
    offsets = {
      {filetype = "neo-tree", text = "file explorer", highlight = "Directory", separator = true },
    },
    hover = {
      enabled = true,
      delay = 100,
      reveal = { "close" },
    },
    groups = {
      items = {
        groups.builtin.pinned:with({ icon = "󰐃 " }),
        groups.builtin.ungrouped,
      },
    },
    close_command = function(n) require("mini.bufremove").delete(n, false) end,
    right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
  },
  highlights = require("catppuccin.special.bufferline").get_theme({
    custom = {all = opaque_highlights },
  }),
})

local map = vim.keymap.set

map("n", "<leader>bP", "<cmd>BufferLineTogglePin<cr>", {desc = "pin/unpin buffer" })
map("n", "<leader>bj", "<cmd>BufferLinePick<cr>", {desc = "jump to buffer (pick)"})
