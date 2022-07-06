return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- enhancement
  use 'tweekmonster/startuptime.vim'
  use 'lewis6991/impatient.nvim'

  -- navigation
  use 'justinmk/vim-dirvish'
  use 'roginfarrer/vim-dirvish-dovish'
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  use 'pbogut/fzf-mru.vim'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-projectionist'
  use 'kshenoy/vim-signature'
  use 'tpope/vim-dispatch'
  use 'simrat39/symbols-outline.nvim'

  -- git
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'junegunn/gv.vim'
  use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }

  -- treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  -- lsp
  use 'neovim/nvim-lspconfig'

  -- dap
  use 'mfussenegger/nvim-dap'
  use 'leoluz/nvim-dap-go'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'tpope/vim-dotenv'

  -- autocompletion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- others
  use 'numToStr/Comment.nvim'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-endwise'
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-abolish'
  use { 'julian/vim-textobj-variable-segment', requires = 'kana/vim-textobj-user' }
  use 'https://gitlab.com/yorickpeterse/nvim-pqf.git'

end)
