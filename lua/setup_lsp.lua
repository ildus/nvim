local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    p = { "<cmd>Telescope find_files<cr>", "Find File" },
    g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
    f = { "<cmd>Telescope buffers<cr>", "Show buffers" },
    o = { "<cmd>NV<cr>", "Notes" },
    l = { "<cmd>set invlist<cr>", "Show hidden symbols" },
    v = { "<cmd>vsplit<cr>", "Split vertically" },
    w = { "<c-w><c-w>", "Switch windows" },
    b = { "<cmd>GDBreak<cr>", "Set gdb breakpoint" },
    x = { "<cmd>GDBreakClear<cr>", "Clear gdb breakpoints" },
    ["."] = { "<cmd>Tags<cr>", "Find by tag" }
  },
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  ["<space>"] = {
    d = {
      name = "Diagnostic",
      f = { "<cmd>vim.diagnostic.open_float<cr>", "Diagnostic: open floating window" },
      l = { "<cmd>vim.diagnostic.setloclist<cr>", "Diagnostic: set location list" },
      p = { "<cmd>vim.diagnostic.goto_prev<cr>", "Diagnostic: previous" },
      n = { "<cmd>vim.diagnostic.goto_next<cr>", "Diagnostic: next" },
    },
    c = {
      name = "LSP Code Actions",
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    },

    f = { "<cmd>lua vim.lsp.buf.format({async = true })<cr>", "LSP Format" },
  },
  g = {
    r = { "<cmd>lua require('telescope.builtin').lsp_references()<cr>", "LSP References" },
    c = { "<cmd>lua require('telescope.builtin').lsp_incoming_calls()<cr>", "LSP Incoming calls" },
    o = { "<cmd>lua require('telescope.builtin').lsp_outgoing_calls()<cr>", "LSP Outgoing calls" },
    s = { "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "LSP Document symbols" },
    i = { "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", "LSP Implementations" },
    d = { "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", "LSP Definitions" },
    t = { "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>", "LSP Type definitions" },
  },
  ["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "LSP Signature help" },
  ["<K>"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "LSP Hover" },
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Disable hightlight
  client.server_capabilities.semanticTokensProvider = nil
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
require('lspconfig')['dartls'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
}
require('lspconfig')['gopls'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    filetypes = {"python"},
}
require('lspconfig')['clangd'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    filetypes = {"c", "sc", "qsc", "h", "sh", "qsh", "cc", "cpp", "hxx"},
}
require('lspconfig')['svlangserver'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
