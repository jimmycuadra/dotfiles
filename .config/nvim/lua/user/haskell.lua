-- Haskell indentation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "haskell",
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
  end,
})
