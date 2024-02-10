vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "Cargo.toml,Cargo.lock,*.rs",
  command = "compiler cargo",
})
