-- Change identation for languages that use 4 spaces instead of 2
local indentation_augroup = vim.api.nvim_create_augroup("indentation", {
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

-- Always open help in a vertical split on the right
vim.cmd([[
  augroup vertical_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
  augroup END
]])

-- Run a command and put its output into a scratch buffer in a new tab
vim.cmd([[
function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)
]])

-- Git commit formatting conventions
vim.api.nvim_create_autocmd("FileType", {
  pattern = "git,gitcommit",
  callback = function()
    vim.opt.textwidth = 72
    vim.opt.colorcolumn = "73"
  end,
})

-- Use LSP for folding if the server supports it
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()

      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})
