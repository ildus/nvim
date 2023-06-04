local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'ressu/vim-xdg-cache',
  'ludovicchabant/vim-gutentags',
  'ntpeters/vim-better-whitespace',
  'plasticboy/vim-markdown',
  { 'psf/black', branch = 'main' },
  {
    'embear/vim-localvimrc',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'folke/which-key.nvim',
    init = function()
      require("setup_wk")
    end
  },
  {
    'ildus/cscope_maps.nvim',
    dependencies = { 'folke/which-key.nvim' }
  },
  'alok/notational-fzf-vim',
  'justinmk/vim-syntax-extra',
  {
    'junegunn/fzf.vim',
    dependencies = {
      {
        'junegunn/fzf',
        build = ':call fzf#install()',
      },
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
      'nvim-telescope/telescope-ui-select.nvim',
    },
    init = function ()
      require('telescope').load_extension('fzf')
      require("telescope").load_extension("ui-select")
    end
  },
  {
    'neovim/nvim-lspconfig',
    init = function()
      require("setup_lsp")
    end
  }
})
