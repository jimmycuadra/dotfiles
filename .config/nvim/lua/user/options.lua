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

  -- Wrap on word bouna
  linebreak = true,

  -- Window splitting
  splitright = true,

  -- Command line completion
  wildmode = "longest:list",
  wildignore = ".git,*.pyc",

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

if vim.fn.executable('rg') then
  vim.opt.grepprg = "rg --vimgrep"
end

-- Strip trailing whitespace on save
vim.cmd [[
function StripTrailingWhitespace()
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction
autocmd BufWritePre * :call StripTrailingWhitespace()
]]
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = "g:StripTrailingWhitespace",
})

-- Each of two vertical splits have a minimum width (at least 100 columns
-- and up to half the number of available columns). The active window will
-- consume as much horizontal space as possible, collapsing the other
-- vertical split to its minimum width.
vim.opt.winwidth = 999
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  command = "let &winminwidth = min([(&columns / 2) - 1, 100])"
})
