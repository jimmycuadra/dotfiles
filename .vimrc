" Compatibility mode
set nocompatible

" Use UTF-8 everywhere
set encoding=utf-8

" BEGIN VIM-PLUG
call plug#begin('~/.vim/plugged')

" install with `brew install fzf`
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" color scheme
Plug 'jgdavey/vim-railscasts'

" multiple cursors
Plug 'mg979/vim-visual-multi'

" comment/uncomment selections
Plug 'tpope/vim-commentary'

" mappings for navigation
Plug 'tpope/vim-ragtag'

" repeat things with . that you normally can't
Plug 'tpope/vim-repeat'

" add, remove, and change things like braces and brackets around objects
Plug 'tpope/vim-surround'

" add faint vertical lines to mark levels of indentation
Plug 'yggdroot/indentline'

" use % to toggle between the start and end of semantic blocks
runtime macros/matchit.vim

" Load all layered packages.
for fpath in split(globpath('~/.vim/layers', '**/packages.vim'), '\n')
  exe 'source' fpath
endfor

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
autocmd VimEnter * let &winminwidth = min([(&columns / 2) - 1, 100])

" Window splitting
set splitright

" Info display
set showcmd
set showmode

" Status line
" fun
set laststatus=2
set statusline=%#CursorLineNr#
set statusline+=%-3n
set statusline+=\ %f
set statusline+=\ %y
set statusline+=\ %h%m%r%w
set statusline+=%=
set statusline+=%-14(%l/%L,%c%V%)
set statusline+=%<%-6P
set statusline+=%2#WarningMsg#
set statusline+=\ %2{coc#status()}
set statusline+=\ %2#PmenuSel#
set statusline+=%{'\ '.FugitiveHead(7).'\ '}

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

" Turn off 'old regexp engine' as suggested by the yats.vim README
set re=0

if executable('rg')
  set grepprg=rg\ --vimgrep
end

" Strip trailing whitespace on save
function <SID>StripTrailingWhitespace()
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespace()

" Mappings
nnoremap <leader><leader> <c-^>
nnoremap <leader>t :make test<cr>
nnoremap <leader>b :make build<cr>
" Copy full file path to clipboard
nnoremap <leader>ffn :let @*=expand('%:p')<cr>
" Copy relative file path to clipboard
nnoremap <leader>fn :let @*=expand('%')<cr>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-p> :Files<cr>
nnoremap <c-b> :Buffers<cr>
nnoremap / /\v

" Call :Writer to enable settings for word processing
" z= in normal mode will fix spelling of the word under the cursor
function! Writer()
  setlocal spell spelllang=en_us
  setlocal formatoptions+=t1
  setlocal textwidth=80
  setlocal noautoindent
  set shiftwidth=5
  set tabstop=5
  set expandtab
  " Reformat the buffer for textwidth to take effect.
  normal! gggqG
endfunction
command! Writer call Writer()

" Load all layered configuration.
for fpath in split(globpath('~/.vim/layers', '**/config.vim'), '\n')
  exe 'source' fpath
endfor
