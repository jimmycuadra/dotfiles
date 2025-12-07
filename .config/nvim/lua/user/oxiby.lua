-- Comments for vim-commentary
vim.api.nvim_create_autocmd("FileType", {
  pattern = "oxiby",
  callback = function()
    vim.opt_local.commentstring = "//"
  end,
})
