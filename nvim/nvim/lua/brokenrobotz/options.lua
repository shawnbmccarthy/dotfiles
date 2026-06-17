-- https://tduyng.com/blog/neovim-basic-setup/
local opt = vim.opt

require('vim._core.ui2').enable({})

-- line navigation
-- relative number is something we should experiment with
--
opt.number = true          -- line numbers
opt.relativenumber = false -- relative line numbers
opt.cursorline = true      -- highlight current line
opt.wrap = false           -- do not wrap lines
opt.scrolloff = 10         -- keep 10 lines above/below cursor
opt.sidescrolloff = 8      -- keep 8 columns left/right of cursor

-- indentation
opt.tabstop = 2       -- tab width
opt.shiftwidth = 2    -- indent width
opt.softtabstop = 2   -- soft tab stop
opt.expandtab = true  -- use spaces instead of tabs
opt.autoindent = true -- copy indent from current line
opt.smartindent = true

-- search settings
-- search for "hello" finds everything, search for "Hello" and
-- it only finds exact matches
opt.ignorecase = true -- case insensitive search
opt.smartcase = true  -- case sensitive if uppercase in search
opt.hlsearch = true   -- do not highlight search results
opt.incsearch = true  -- show matches as you type

-- visual settings
opt.termguicolors = true -- enable 24-bit colors
opt.signcolumn = "yes"   -- always show sign column
opt.showmatch = true     -- highlight matching brackets
opt.matchtime = 2        -- how long to show matching bracket
opt.cmdheight = 1        -- command line height
opt.showmode = false     -- do not show mode in command line
opt.pumheight = 10       -- popup menu height
opt.pumblend = 10        -- popup menu transparency
opt.winblend = 0         -- floating window transparency
opt.completeopt = "menu,menuone,noselect,popup"
vim.o.autocomplete = true
opt.conceallevel = 2      -- hide * markup for bold & italic, but not markers with substitutions
opt.confirm = true        -- confirm to save changes before exiting modified buffer
opt.concealcursor = ""    -- do not hide cursor line markup
opt.synmaxcol = 300       -- syntax highlighting limit
opt.ruler = false         -- disable the default ruler
opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
opt.winminwidth = 5       -- minimum window width

-- file handling
opt.backup = false      -- do not create backup files
opt.writebackup = false -- do not create backup before writing
opt.swapfile = false    -- do not create swap files
opt.undofile = true     -- persistent undo
-- opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.updatetime = 250    -- faster completion

-- lower than default (1000) to quickly trigger which-key
opt.timeoutlen = vim.g.vscode and 1000 or 300
opt.ttimeoutlen = 0  -- key code timeout
opt.autoread = true  -- auto reload files changed outside vim
opt.autowrite = true -- autosave

-- behavior settings
opt.hidden = true           -- allow for hidden buffers
opt.errorbells = false      -- no error bells
opt.backspace = "indent,eol,start"
opt.autochdir = false       -- do not auto change directory
opt.iskeyword:append("-")   -- treat dash as part of word
opt.path:append("**")       -- include subdirectories in search
opt.selection = "exclusive" -- selection behavior
opt.mouse = "a"             -- enable mouse support
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.modifiable = true       -- allow buffer modifications
opt.encoding = "utf-8"      -- set encoding

-- folding settings
opt.smoothscroll = true
vim.wo.foldmethod = "expr"
opt.foldlevel = 99 -- all folds open
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- split behavior
opt.splitbelow = true -- horizontal splits go below
opt.splitright = true -- vertical splits go right
opt.splitkeep = "screen"

-- command-line completion
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- better diff options
opt.diffopt:append("linematch:60")

-- performance improvements
opt.redrawtime = 10000
opt.maxmempattern = 20000

opt.jumpoptions = "view"
opt.laststatus = 3    -- global statusline
opt.list = false
opt.linebreak = true  -- wrap lines a convient points
opt.shiftround = true -- round indent
opt.shiftwidth = 2    -- size of indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
