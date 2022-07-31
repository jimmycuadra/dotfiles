-- Syntax for Helm templates (Go templates inside YAML)
local augroup = vim.api.nvim_create_augroup("helm_syntax", { clear = true })

vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
  group = augroup,
  pattern = "*/templates/*.yaml,*/templates/*.tpl",
  callback = function()
    vim.bo.filetype = "yaml"
    vim.api.nvim_buf_del_var(0, "current_syntax")
    vim.cmd([[syn include @yamlGoTextTmpl syntax/gotexttmpl.vim]])
    vim.api.nvim_buf_set_var(0, "current_syntax", "yaml")
    vim.cmd([[
      syn region goTextTmpl start=/{{/ end=/}}/ contains=@gotplLiteral,gotplControl,gotplFunctions,gotplVariable,goTplIdentifier containedin=ALLBUT,goTextTmpl keepend
      hi def link goTextTmpl PreProc
    ]])
  end,
})
