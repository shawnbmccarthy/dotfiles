require("nvim-treesitter").install({
  "rust", "python", "c", "cpp", "java", "javascript", "typescript", "tsx",
  "lua", "go", "gomod", "qmljs", "cmake", "make",
  "markdown", "markdown_inline", "json", "toml", "yaml", "bash", "fish", "kdl",
  "vim", "vimdoc", "query",
}) -- runs in the background; skips parsers that are already installed

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("brokenrobotz-treesitter", { clear = true }),
  callback = function(ev)
    -- quietly does nothing for filetypes without a parser (neo-tree, telescope, ...)
    if not pcall(vim.treesitter.start, ev.buf) then
      return
    end
    -- treesitter-based indent (experimental); remove if a language indents badly
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
