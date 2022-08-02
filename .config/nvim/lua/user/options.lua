-- Leader
vim.g.mapleader = ","

local options = {
  -- Tab stops
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  expandtab = true,

  -- Line numbers
  number = true,
  ruler = true,
  colorcolumn = "101",
  cursorline = true,

  -- Global status line
  laststatus = 3,

  -- Wrap on word bouna
  linebreak = true,

  -- Window splitting
  splitright = true,

  -- Command line completion
  wildmode = "longest:list",
  wildignore = ".git,*.pyc",

  -- Show autocompletion for any number of options
  completeopt = { "menu", "menuone" },

  -- Searching
  ignorecase = true,
  smartcase = true,

  -- Don't beep
  visualbell = true,

  -- Use the system clipboard for yank and paste
  clipboard = "unnamed,unnamedplus",

  -- Don't redraw the screen during macro execution
  lazyredraw = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep"
end

-- Change identation for languages that use 4 spaces instead of 2
local indentation_augroup = vim.api.nvim_create_augroup("identation", {
  clear = true,
})
vim.api.nvim_create_autocmd("FileType", {
  group = indentation_augroup,
  pattern = "go,elm,haskell,python",
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
  end,
})

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local curpos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, curpos)
  end,
})

-- Each of two vertical splits have a minimum width (at least 100 columns
-- and up to half the number of available columns). The active window will
-- consume as much horizontal space as possible, collapsing the other
-- vertical split to its minimum width.
vim.opt.winwidth = 999
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  command = "let &winminwidth = min([(&columns / 2) - 1, 100])",
})
