local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(
    mode,
    lhs,
    rhs,
    { silent = true, noremap = true, desc = desc }
  )
end

local M = {}

local function listed_buffers()
  return vim.tbl_filter(function(b)
    return vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())
end

local function neo_tree_open()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree" then
      return true
    end
  end
  return false
end

local function close_non_neotree_windows()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "neo-tree" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
end

local function switch_to_other_buffer(buf)
  local alt = vim.fn.bufnr("#")
  if alt ~= -1 and alt ~= buf and vim.bo[alt].buflisted then
    vim.cmd.buffer(alt)
    return
  end

  vim.cmd.bnext()
  if vim.api.nvim_get_current_buf() == buf then
    vim.cmd.bprevious()
  end
end

-- Switch away before deleting so the edit window stays open (needed with neo-tree).
function M.delete_buffer(bang)
  local buf = vim.api.nvim_get_current_buf()

  if not vim.bo[buf].buflisted then
    vim.cmd.bdelete({ bang = bang, args = { buf } })
    return
  end

  local listed = listed_buffers()
  local other_listed = vim.tbl_filter(function(b)
    return b ~= buf
  end, listed)

  if #other_listed == 0 then
    if neo_tree_open() and vim.bo[buf].filetype ~= "neo-tree" then
      vim.cmd.bdelete({ bang = bang, args = { buf } })
      close_non_neotree_windows()
      return
    end

    if vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].modified then
      vim.cmd.enew()
    end
  else
    switch_to_other_buffer(buf)
  end

  vim.cmd.bdelete({ bang = bang, args = { buf } })
end

vim.api.nvim_create_user_command("Bdelete", function(opts)
  M.delete_buffer(opts.bang)
end, { bang = true, desc = "Delete buffer without closing neo-tree or Neovim" })

vim.cmd("cnoreabbrev bd Bdelete")
vim.cmd("cnoreabbrev bdelete Bdelete")

-- basic helpers
map("n", "<leader>w", "<cmd>write<cr>", "save file")
map("n", "<leader>q", "<cmd>quit<cr>", "quit")
map("n", "<leader>bd", function()
  M.delete_buffer(false)
end, "delete buffer")

-- tab helpers
map("n", "<leader>tn", "<cmd>tabnew<cr>", "new blank tab")
map("n", "<leader>tc", "<cmd>tabc<cr>", "close current tab")
map("n", "<leader>to", "<cmd>tabo<cr>", "close other tabs")

-- clear search
map("n", "<leader><space>", "<cmd>nohlsearch<cr>", "clear search")

-- mov between windows

-- resize splits with arrows

-- lsp

return M
