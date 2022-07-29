-- Colors
vim.cmd "colorscheme railscasts"

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

  -- Window sizing
  winwidth = 999,

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

-- Load all layered configuration.
local paths = vim.fn.split(
  vim.fn.globpath("~/.config/nvim/lua/user", "**/config.lua"),
  "\n"
)
for _, path in ipairs(paths) do
  local _, _, mod = string.find(path, "(user/.*/config)")
  mod = string.gsub(mod, "/", ".")
  require(mod)
end
