syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu relativenumber
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch

set backspace=indent,eol,start

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey


call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'leafgarland/typescript-vim'
Plug 'mbbill/undotree'

Plug 'mcchrish/nnn.vim'

call plug#end()


colorscheme gruvbox
set background=dark


set splitbelow splitright
nmap <silent> zs :wincmd s<cr>
nmap <silent> zv :wincmd v<cr>
nmap <silent> zx :wincmd x<cr>
nmap <silent> zo :wincmd o<cr>

nmap <silent> zh :wincmd h<cr>
nmap <silent> zj :wincmd j<cr>
nmap <silent> zl :wincmd l<cr>
nmap <silent> zk :wincmd k<cr>

let mapleader=" "

" fzf
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>e :History<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>r :Rg<cr>

" nnn
let g:nnn#set_default_mappings = 0
let g:nnn#layout = {'window': {'width': 0.9, 'height': 0.7, 'highlight': 'Debug' } }
let g:nnn#command = 'nnn -H'
let g:nnn#action = {
    \ '<c-x>': 'split',
    \ '<c-v>': 'vsplit',
    \ '<c-t>': 'tab split' }
nnoremap <silent> <leader>nn :NnnPicker<CR>

" git
nmap <leader>gh :diffget //3<cr>
nmap <leader>gf :diffget //2<cr>
