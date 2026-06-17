require("fidget").setup({
  progress = {
    clear_on_detach = function(client_id)
      local client = vim.lsp.get_client_by_id(client_id)
      return client and client.name or nil
    end,
    notification_group = function(msg)
      return msg.lsp_client.name
    end,
    ignore = {},
    display = {
      done_icon = "✔",
      progress_icons = { "dots" },
    },
  },
})

vim.notify = require("fidget").notify
