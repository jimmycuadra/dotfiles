local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
  return
end
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_ok then
  return
end
local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
  return
end

local o = vim.opt

-- Add more space for messages
o.cmdheight = 2

-- Display signs over line numbers
o.signcolumn = "number"

-- Configure diagnostics
vim.diagnostic.config({
  -- Only show diagnostics in floating windows
  virtual_text = false,
  float = {
    -- Show which LSP source produced the diagnostic
    source = true,
  },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  width = 60,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  width = 60,
})

local map = vim.keymap.set

local opts = { silent = true }

-- Navigate diagnostics
map("n", "[g", vim.diagnostic.goto_prev, opts)
map("n", "]g", vim.diagnostic.goto_next, opts)
map("n", "<leader>q", vim.diagnostic.setloclist, opts)

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
  map("n", "gy", vim.lsp.buf.type_definition, buffer_opts)
  map("n", "gi", vim.lsp.buf.implementation, buffer_opts)

  map("n", "<leader>F", vim.lsp.buf.formatting, buffer_opts)
  map("x", "<leader>F", vim.lsp.buf.range_formatting, buffer_opts)
  map("n", "<leader>c", vim.lsp.buf.code_action, buffer_opts)
  map("x", "<leader>c", vim.lsp.buf.range_code_action, buffer_opts)
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
  init_options = {
    formatting = false,
  },
  settings = {
    solargraph = {
      diagnostics = false,
    },
  },
})

-- brew install sqls
lspconfig.sqls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- brew install lua-language-server
lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = runtime_path,
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
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.stdpath("config") .. "/lua",
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
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
  -- gem install rubocop
  sources = {
    code_actions.eslint,
    diagnostics.eslint,
    diagnostics.flake8,
    diagnostics.rubocop,
    formatting.black,
    formatting.eslint,
    formatting.prettier,
    formatting.rubocop,
    formatting.stylua,
  },
})
