local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.setup_servers({
  'bashls',
  'clangd',
  'lua_ls',
  'pyright',
  'rust_analyzer',
  'texlab',
})

-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})


lsp.on_attach(function(client, bufnr)
  -- lsp.default_keymaps({buffer = bufnr})
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "]g", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "[g", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>qf", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  -- TODO unbind this from Shift-Backspace
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

local cmp = require('cmp')

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
})

cmp.setup({
  completion = {
    keyword_length = 1,
    -- https://github.com/hrsh7th/nvim-cmp/discussions/1392
    keyword_pattern = ".*",
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
  mapping = cmp_mappings,
})

lsp.setup()
