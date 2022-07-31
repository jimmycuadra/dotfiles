local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then return end
local luasnip_ok, luasnip = pcall(require, "luasnip")
if not luasnip_ok then return end

-- Nerd Font glyphs
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<up>"] = cmp.mapping.scroll_docs(-5),
    ["<down>"] = cmp.mapping.scroll_docs(5),
    ["<cr>"] = cmp.mapping.confirm(),
    ["<tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        fallback()
      end
    end),
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind] or "?")
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snp]",
        buffer = "[Buf]",
        path = "[Pth]",
      })[entry.source.name] or entry.source.name

      return vim_item
    end,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
})
