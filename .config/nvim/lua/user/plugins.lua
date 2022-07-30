vim.call("plug#begin")

local Plug = vim.fn["plug#"]

-- install with `brew install fzf`
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

-- color scheme
Plug 'jgdavey/vim-railscasts'

-- multiple cursors
Plug 'mg979/vim-visual-multi'

-- comment/uncomment selections
Plug 'tpope/vim-commentary'

-- mappings for navigation
Plug 'tpope/vim-ragtag'

-- repeat things with . that you normally can't
Plug 'tpope/vim-repeat'

-- add, remove, and change things like braces and brackets around objects
Plug 'tpope/vim-surround'

-- add faint vertical lines to mark levels of indentation
Plug 'yggdroot/indentline'

-- Load all layered packages.
vim.cmd("runtime! lua/user/**/packages.lua")

vim.call("plug#end")
