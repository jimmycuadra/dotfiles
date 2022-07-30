local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then return end
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_nvim_lsp_ok then return end
local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then return end

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

-- yarn global add bash-language-server
lspconfig.bashls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- yarn global add dockerfile-language-server-nodejs
lspconfig.dockerls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- brew install pyright
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- brew install rust-analyzer
-- rustup component add rust-src
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- gem install solargraph
lspconfig.solargraph.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    diagnostics = false,
  },
})

-- brew install sqls
lspconfig.sqls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- brew install lua-language-server
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
        disable = {
          -- The server isn't smart enough to know that if a module is
          -- required with `pcall` and we return when it isn't successful,
          -- then the module is not `nil` past that point.
          "need-check-nil",
        },
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

-- yarn global add typescript-language-server
lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

local builtins = null_ls.builtins
local code_actions = builtins.code_actions
local diagnostics = builtins.diagnostics
local formatting = builtins.formatting

null_ls.setup({
  -- brew install black eslint flake8 prettier stylua
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
