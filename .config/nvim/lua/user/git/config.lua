-- Git commit formatting conventions
vim.api.nvim_create_autocmd("FileType", {
  pattern = "git,gitcommit",
  callback = function()
    vim.opt.textwidth = 72
    vim.opt.colorcolumn = "73"
  end,
})
