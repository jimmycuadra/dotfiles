" Compatibility mode
set nocompatible

" Use UTF-8 everywhere
set encoding=utf-8

" BEGIN VIM-PLUG
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'jgdavey/vim-railscasts'
Plug 'kchmck/vim-coffee-script'
Plug 'elzr/vim-json'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'ekalinin/Dockerfile.vim'
Plug 'cespare/vim-toml'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'bkad/vim-terraform'
Plug 'uarun/vim-protobuf'
Plug 'nginx/nginx', {'rtp': 'contrib/vim/'}
Plug 'elixir-lang/vim-elixir'
Plug 'ElmCast/elm-vim'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp' " deoplete.nvim needs this for regular vim
Plug 'roxma/vim-hug-neovim-rpc' " nvim-yarp needs this for regular vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/tsuquyomi'
Plug 'rust-lang/rust.vim'
call plug#end()
" END VIM-PLUG

" Colors
colorscheme railscasts

" Leader
let mapleader=","

" Tab stops
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
autocmd FileType elm set tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType go set tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType haskell set tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType python set tabstop=4 softtabstop=4 shiftwidth=4

" File types
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

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
set winwidth=999
autocmd VimEnter * :call SetWinMinWidth()
function SetWinMinWidth()
  let min=(&columns / 2) - 1
  if min < 100
    let &winminwidth=min
  else
    set winminwidth=100
  end
endfunction

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

" Don't insert extra spaces when joining lines.
set nojoinspaces

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
set clipboard=unnamed,unnamedplus

" Allow backspace to remove line breaks and auto-indentation
" Why is this necessary???
set backspace=2
" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100

" Don't redraw the screen during macro execution
set lazyredraw

if executable('rg')
  set grepprg=rg\ --vimgrep
end

" vim-json
let g:vim_json_syntax_conceal = 0

" elm-vim
let g:elm_format_autosave = 1

" vim-markdown
let g:markdown_fenced_languages = [
\  'bash=sh',
\  'haskell',
\  'hcl=terraform',
\  'html',
\  'javascript',
\  'json',
\  'python',
\  'ruby',
\  'rust',
\  'yaml',
\]

" deoplete.nvim
let g:deoplete#enable_at_startup = 1

" LanguageClient-neovim
let g:LanguageClient_serverCommands = {
\  'rust': ['~/.cargo/bin/rls'],
\}

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
nnoremap <c-p> :Files<cr>
nnoremap p :Buffers<cr>
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<cr>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<cr>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<cr>
nnoremap / /\v
