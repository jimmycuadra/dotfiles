" Compatibility mode
set nocompatible

" BEGIN VUNDLE
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'skalnik/vim-vroom'
Plugin 'jgdavey/vim-railscasts'
Plugin 'kchmck/vim-coffee-script'
Plugin 'elzr/vim-json'
Plugin 'tpope/vim-surround'
Plugin 'jnwhiteh/vim-golang'
Plugin 'tpope/vim-markdown'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'rust-lang/rust.vim'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'tpope/vim-commentary'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'cespare/vim-toml'
Plugin 'Matt-Deacalion/vim-systemd-syntax'
Plugin 'bkad/vim-terraform'
Plugin 'uarun/vim-protobuf'
Plugin 'nginx/nginx', {'rtp': 'contrib/vim/'}
Plugin 'elixir-lang/vim-elixir'
Plugin 'lambdatoast/elm.vim'
call vundle#end()
filetype plugin indent on
" END VUNDLE

set rtp+=/usr/local/opt/fzf

" Colors
colorscheme railscasts

" Syntax highlighting
syntax on

" Leader
let mapleader=","

" Tab stops
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
autocmd FileType python set tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType go set tabstop=4 softtabstop=4 shiftwidth=4

" Line numbers
set number
set ruler
set colorcolumn=101
set cursorline
hi LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
hi ColorColumn term=bold cterm=NONE ctermfg=NONE ctermbg=234 gui=NONE guifg=NONE guibg=#1c1c1c

" Wrap on word boundaries
set linebreak

" Window sizing
set winwidth=100
set winminwidth=100
set winwidth=999

" Window splitting
set splitright

" Info display
set showcmd
set showmode

" Status line
set laststatus=2
set statusline=%-10.3n\
set statusline+=%f\
set statusline+=%h%m%r%w
set statusline+=\[%{strlen(&ft)?&ft:'none'}]
set statusline+=%=
set statusline+=%-14(%l,%c%V%)
set statusline+=%<%P

" Buffers
set hidden
" Remove file from buffer without losing the window
nmap <leader>d :b#<bar>bd#<CR>

" Automatically reload files that change on disk
set autoread

" Command line completion
set wildmenu
set wildmode=longest:list
set wildignore=.git,*.pyc

" Searching
set ignorecase
set smartcase
set incsearch
set hlsearch
:nnoremap <cr> :nohlsearch<cr>

" Visual bell
set visualbell

set directory=$HOME/.vim/swap//

" System clipboard
set clipboard=unnamed

" Allow backspace to remove line breaks and auto-indentation
" Why is this necessary???
set backspace=2
" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100

" ctrlp.vim
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" vim-json
let g:vim_json_syntax_conceal = 0

" Strip trailing whitespace on save
function! <SID>StripTrailingWhitespace()
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespace()

" Insert literal tab or command complete
function TabOrComplete()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=TabOrComplete()<cr>
inoremap <s-tab> <c-n>

" Compilers
autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo

" Mappings
nnoremap <leader><leader> <c-^>
nnoremap <leader>t :make test<cr>
nnoremap <leader>b :make build<cr>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
