syntax on

filetype plugin indent on       " filetype detection[ON] plugin[ON] indent[ON]
set backspace=indent,eol,start  " make backspace works
set listchars=tab:>~,nbsp:_,trail:.
set list
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab                   " use spaces instead of tabs
set smarttab                    " use tabs at the start of the line
set smartindent
set showmatch                   " show match bracket
set number relativenumber       " show both line number and relative
set nowrap                      " disable wrapping
set incsearch                   " highlight as you type your search
set encoding=utf-8              " how vim represents characters on the screen
set fileencoding=utf-8          " set the encoding of files written
set noerrorbells visualbell     " flash screen instead of beep sound
set noswapfile
set cursorline                  " highlight cursor line
set cursorcolumn                " highlight cursor column
set mouse=a                     " select text using mouse to enable visual mode

colorscheme gruvbox
set background=dark

let mapleader=" "

" fzf
set rtp+=/home/nam/dotfiles/fzf
let g:fzf_layout = { 'window': {
                    \ 'width': 0.9,
                    \ 'height': 0.7,
                    \ 'highlight': 'Comment',
                    \ 'rounded': v:false }}
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>e :History<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>r :Rg<cr>
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview(), <bang>0)


" coc.nvim
set hidden          " TextEdit might fail if hidden is not set
set nobackup        " some servers have issues with backup files
set nowritebackup
set cmdheight=2     " give more space for displaying messages
set updatetime=100  " default is 4000 ms = 4s
set shortmess+=c    " don't pass messages to ins-completion-menu
set signcolumn=yes  " show signcolumn
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
function! GoCoc()
    " use tab for trigger completion with characters ahead and navigate
    inoremap <buffer> <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <buffer> <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    inoremap <buffer> <silent><expr> <C-space> coc#refresh()
endfunction

autocmd FileType go :call GoCoc()
