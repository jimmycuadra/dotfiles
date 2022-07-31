-- Color scheme
vim.cmd([[
try
  colorscheme railscasts
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])

-- Make the right edge column gray instead of red
vim.cmd("hi ColorColumn ctermbg=234 guibg=#1c1c1c")
