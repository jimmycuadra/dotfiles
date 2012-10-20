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

" Line numbers
set number
set ruler
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

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

" Mappings
nnoremap <leader><leader> <c-^>

