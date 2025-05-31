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

if (os.getenv('SSH_TTY') == nil)
then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end

require("lazy").setup({
  'ressu/vim-xdg-cache',
  'ntpeters/vim-better-whitespace',
  'plasticboy/vim-markdown',
  "ibhagwan/fzf-lua",
  {
    'embear/vim-localvimrc',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
    },
    init = function()
      require('telescope').load_extension('fzf')
      require("telescope").load_extension("ui-select")
    end
  },
  {
    'folke/which-key.nvim',
    init = function()
      require("setup_wk")
    end
  },
  {
    "dhananjaylatkar/cscope_maps.nvim",
    dependencies = {
      "folke/which-key.nvim",
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
    },
    opts = {
      skip_input_prompt = true,

      cscope = {
        picker = "telescope", -- "telescope", "fzf-lua"
        -- "true" does not open picker for single result, just JUMP
        skip_picker_for_single_result = true,
      }
    },
  },
  'justinmk/vim-syntax-extra',
  {
    'neovim/nvim-lspconfig',
    init = function()
      require("setup_lsp")
    end
  },
})
