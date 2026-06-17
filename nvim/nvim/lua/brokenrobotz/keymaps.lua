local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- tab/shift: like browswer tabs
map("n", "<Tab>", ":bnext<cr>", { desc = "next buffer" })
map("n", "<S-Tab>", ":bprevious<cr>", { desc = "previous buffer" })

-- alternative buffer switching
map("n", "<leader>bn", ":bnext<cr>", { desc = "next buffer" })
map("n", "<leader>bp", ":bprevious<cr>", { desc = "previous buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "previous buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "next buffer" })

-- quick switch to last edited file
-- not sure how this is used yet
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "switch to other buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "switch to other buffer" })

-- move between windows
map("n", "<C-h>", "<C-w>h", { desc = "go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "go to right window", remap = true })

-- resize windows
map("n", "<C-S-Up>", "<cmd>resize +5<cr>", opts)
map("n", "<C-S-Down>", "<cmd>resize -5<cr>", opts)
map("n", "<C-S-Left>", "<cmd>vertical resize -5<cr>", opts)
map("n", "<C-S-Right>", "<cmd>vertical resize +5<cr>", opts)

-- window splitting
map("n", "<leader>ww", "<C-W>p", { desc = "other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "split window below", remap = true })
map("n", "<leader>sh", "<C-W>s", { desc = "split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "split window right", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "split window right", remap = true })
map("n", "<leader>sv", "<C-W>v", { desc = "split window right", remap = true })

-- smart j/k: move by visual lines wne no count, real lines with count
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "up", expr = true, silent = true })

-- move lines up/down: vscode
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "move down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "move up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "move down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "move up" })

-- alternative line movement
map("v", "J", ":move '>+1<cr>gv=gv", { desc = "move block down" })
map("v", "K", ":move '<-2<cr>gv=gv", { desc = "move block up" })
map("n", "<A-Down>", ":m .+1<cr>", opts)
map("n", "<A-Up>", ":m .-2<cr>", opts)
map("i", "<A-Down>", "<esc>:m .+1<cr>==gi", opts)
map("i", "<A-Up>", "<esc>:m .-2<cr>==gi", opts)
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", opts)
map("v", "<A-Up>", ":m '<-2<cr>gv=gv", opts)

-- better line start/end 
map("n", "gl", "$", { desc = "go to end of line" })
map("n", "gh", "^", { desc = "go to start of line" })
map("n", "<A-h>", "^", { desc = "go to start of line", silent = true })
map("n", "<A-l>", "$", { desc = "go to end of line", silent = true })

-- select all content
map("n", "==", "gg<S-v>G")
map("n", "<A-a>", "ggVG", { noremap = true, silent = true, desc = "select all" })

-- clear search highlighting
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "escape and clear hlsearch" })
map("n", "<leader>ur", "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><CR>", { desc = "redraw / clear hlsearch / diff update" })

-- smart search navigation
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "previous search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "previous search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "previous search result" })

-- indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- paste (does not replace clipboard with deleted text)
map("v", "p", '"_dP', opts)

-- copy whole file to clipboard
map("n", "<C-c>", ":%y+<CR>", opts)

-- smart undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- auto close pairs (without plugin) -- don't like this
-- map("i", "`", "``<left>")
-- map("i", '"', '""<left>')
-- map("i", "(", "()<left>")
-- map("i", "[", "[]<left>")
-- map("i", "{", "{}<left>")
-- map("i", "<", "<><left>")

-- commenting (add comment above/below current line) - not sure yet
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "add comment below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "add comment above" })

-- quickfix & location lists
map(
  "n",
  "<leader>xl",
  function()
    local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
    if not success and err then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end,
  { desc = "location list" }
)

map(
  "n",
  "<leader>xq",
  function()
    local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
    if not success and err then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end,
  { desc = "quickfix list" }
)

map("n", "[q", vim.cmd.cprev, { desc = "previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "next quickfix" })

-- inspection tools -> not sure about this just yet
map("n", "<leader>ui", vim.show_pos, { desc = "inspect pos" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "inspect tree" })

-- keyword program -> not sure this is useful (maybe)
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "keyword program" })

-- terminal mode navigation >> NAH
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "enter normal mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "go to right window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "hide terminal" })
map("t", "<C-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- tab management
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "last tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "close other tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "first tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "new tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "next tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "close tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "previous tab" })

-- folding navigation
map("n", "zv", "zMzvzz", { desc = "close all folds except the current one" })

-- smart fold navigation
map("n", "zj", "zcjzOzz", { desc = "close current fold when open, always open next fold" })
map("n", "zk", "zckzOzz", { desc = "close current fold when open, always open previous fold" })

-- toggle line wrapping
map("n", "<leader>tw", "<cmd>set wrap!<cr>", { desc = "toggle wrap", silent = true })

-- fix spelling (picks 1st suggestion)
map("n", "z0", "1z=", { desc = "fix word under cursor" })
