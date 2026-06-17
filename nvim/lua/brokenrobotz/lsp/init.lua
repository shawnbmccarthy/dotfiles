local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, {
    buffer = true,
    silent = true,
    noremap = true,
    desc = desc,
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client_id = args.data.client_id
    if not client_id then
      return
    end

    local client = vim.lsp.get_client_by_id(client_id)
    if not client then
      return
    end

    if not vim.b[bufnr].lsp_keymaps_set then
      vim.b[bufnr].lsp_keymaps_set = true

      map("n", "gd", vim.lsp.buf.definition, "goto definition")
      map("n", "gD", vim.lsp.buf.declaration, "goto declaration")
      map("n", "gr", vim.lsp.buf.references, "goto references")
      map("n", "gi", vim.lsp.buf.implementation, "goto implementation")
      map("n", "gt", vim.lsp.buf.type_definition, "goto type definition")
      map("n", "K", vim.lsp.buf.hover, "hover docs")
      map("n", "<leader>ca", vim.lsp.buf.code_action, "code action")
      map("n", "<leader>cr", vim.lsp.buf.rename, "rename")
      map("n", "<leader>cf", function()
        vim.lsp.buf.format({ bufnr = bufnr, async = false })
      end, "format buffer")
      map({ "n", "x" }, "<leader>cf", function()
        vim.lsp.buf.format({ bufnr = bufnr, async = false })
      end, "format selection")
    end

    if client.name == "pyright" then
      map("n", "<leader>co", function()
        client.request("workspace/executeCommand", {
          command = "pyright.organizeimports",
          arguments = { vim.uri_from_bufnr(bufnr) },
        }, nil, bufnr)
      end, "organize imports")
    end

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client_id, bufnr, {
        autotrigger = true,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("autoformat", { clear = true }),
  callback = function(args)
    if not vim.g.autoformat then
      return
    end

    local bufnr = args.buf
    if vim.bo[bufnr].filetype == "" or not vim.bo[bufnr].modifiable then
      return
    end

    local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/formatting" })
    if #clients == 0 then
      return
    end

    vim.lsp.buf.format({
      bufnr = bufnr,
      async = false,
      timeout_ms = 3000,
      filter = function(c)
        if vim.bo[bufnr].filetype == "python" then
          return c.name == "ruff"
        end
        return true
      end,
    })
  end,
})

require("brokenrobotz.lsp.lua_ls")
require("brokenrobotz.lsp.qml_ls")
require("brokenrobotz.lsp.rust_ls")
require("brokenrobotz.lsp.python_ls")
require("brokenrobotz.lsp.go_ls")
