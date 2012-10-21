" Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" Compatibility mode
set nocompatible

" Syntax highlighting
syntax on

" Leader
let mapleader=","

" Tab stops
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
filetype indent on

" Line numbers
set number
set ruler
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" Colors
colorscheme railscasts

" Info display
set showcmd
set showmode

" Buffers
set hidden

" Command line completion
set wildmenu
set wildmode=list:longest

" Searching
set ignorecase
set smartcase
set incsearch
set hlsearch

" Visual bell
set visualbell

" Vroom
let g:vroom_use_bundle_exec = 0

" Mappings
nnoremap <leader><leader> <c-^>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

