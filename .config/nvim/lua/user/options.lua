-- Leader
vim.g.mapleader = ","

-- Set options
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

  -- Statusline
  laststatus = 3,
  statusline = "%!v:lua.require'user.statusline'.statusline()",
  showmode = false,

  -- Wrap on word boundaries
  linebreak = true,

  -- Window splitting
  splitbelow = true,
  splitright = true,

  -- Command line completion
  wildmode = "longest:list",
  wildignore = ".git,*.pyc",

  -- Show autocompletion for any number of options
  completeopt = { "menu", "menuone" },

  -- Searching
  ignorecase = true,
  smartcase = true,
  hlsearch = false,

  -- Don't beep
  visualbell = true,

  -- Use the system clipboard for yank and paste
  clipboard = "unnamed,unnamedplus",

  -- Don't redraw the screen during macro execution
  lazyredraw = true,

  -- Time to wait after last input before CursorHold event fires
  updatetime = 1000,

  -- Use a rounded border on all floating windows.
  winborder = "rounded",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep"
end

-- Each of two vertical splits have a minimum width (at least 100 columns
-- and up to half the number of available columns). The active window will
-- consume as much horizontal space as possible, collapsing the other
-- vertical split to its minimum width.
vim.opt.winwidth = 999
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  command = "let &winminwidth = min([(&columns / 2) - 1, 100])",
})
