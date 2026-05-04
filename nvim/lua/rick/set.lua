-- Line Number
vim.keymap.set("n", "<D-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<D-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indents
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Wrap
vim.opt.wrap = false

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Looks
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8

-- Behavior
vim.opt.updatetime = 50
vim.opt.isfname:append("@-@")


vim.g.mapleader = " "
