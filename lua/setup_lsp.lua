-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Disable hightlight
  client.server_capabilities.semanticTokensProvider = nil
end

local lspconfig = require('lspconfig')

function installed(set, key)
    return set[key] ~= nil
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

lspconfig['dartls'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
lspconfig['rust_analyzer'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
}
lspconfig['gopls'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
lspconfig['clangd'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    filetypes = {"c", "sc", "qsc", "h", "qsh", "cc", "cpp", "hxx"},
}
lspconfig['verible'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
lspconfig['ruff'].setup({
    on_attach = on_attach,
    flags = lsp_flags,
    filetypes = {"python"},
})

-- or pyright
if installed(lspconfig, 'jedi_language_server') then
    lspconfig['jedi_language_server'].setup{
      on_attach = on_attach,
      flags = lsp_flags,
      filetypes = {"python"},
    }
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of jedi
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})
