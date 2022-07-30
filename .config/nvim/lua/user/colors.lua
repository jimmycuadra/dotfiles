-- Color scheme
vim.cmd [[
try
  colorscheme railscasts
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
