local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local null_ls = require("null-ls")

local o = vim.opt

-- Add more space for messages
o.cmdheight = 2

-- Display signs over line numbers
o.signcolumn = "number"

local map = vim.keymap.set

local opts = { silent = true }

map('n', '<leader>e', vim.diagnostic.open_float, opts)
map('n', '[g', vim.diagnostic.goto_prev, opts)
map('n', ']g', vim.diagnostic.goto_next, opts)
map('n', '<leader>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  local buffer_opts = { silent = true, buffer = bufnr }

  -- Prefer formatting from null-ls
  if client.name == "tsserver" or client.name == "sumneko_lua" then
    client.resolved_capabilities.document_formatting = false
  end

  map("n", "K", vim.lsp.buf.hover, buffer_opts)

  map("n", "gd", vim.lsp.buf.definition, buffer_opts)
  map("n", "gD", vim.lsp.buf.declaration, buffer_opts)
  map("n", "gr", vim.lsp.buf.references, buffer_opts)
  map("n", "gt", vim.lsp.buf.type_definition, buffer_opts)
  map("n", "gi", vim.lsp.buf.implementation, buffer_opts)

  map("n", "<leader>F", vim.lsp.buf.formatting, buffer_opts)

  map("n", "lc", vim.lsp.buf.code_action, buffer_opts)
end

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.solargraph.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    diagnostics = false,
  },
})

lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  }
})

lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting


null_ls.setup({
  sources = {
    code_actions.eslint,
    diagnostics.eslint,
    diagnostics.flake8,
    formatting.black,
    formatting.eslint,
    formatting.prettier,
    formatting.stylua,
  },
})
