" Compatibility mode
set nocompatible

" Use UTF-8 everywhere
set encoding=utf-8

" BEGIN VIM-PLUG
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-repeat'
Plug 'jgdavey/vim-railscasts'
Plug 'kchmck/vim-coffee-script'
Plug 'elzr/vim-json'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
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
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
" To find the version of Python Vim is using:
" :pyx import os
" :pyx print(os.path.join(os.__file__.split("lib/")[0], "bin", "python3"))
" Then from the shell, run `absolute_path_to_python3 -m pip install neovim`.
endif
" install with `brew install fzf`
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'yggdroot/indentline'
Plug 'tpope/vim-ragtag'

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
autocmd FileType elm set tabstop=4 softtabstop=4 shiftwidth=4
autocmd FileType go set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
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
autocmd VimEnter * let &winminwidth = min([(&columns / 2) - 1, 100])

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
" Close the preview window automatically after completion
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif

" LanguageClient-neovim
let g:LanguageClient_serverCommands = {
\  'go': ['/usr/bin/env', 'gopls', '-remote', 'auto'],
\  'python': ['/usr/bin/env', 'pyls'],
\  'rust': ['/usr/bin/env', 'rust-analyzer'],
\  'javascript': ['/usr/bin/env', 'typescript-language-server', '--stdio'],
\  'typescript': ['/usr/bin/env', 'typescript-language-server', '--stdio'],
\  'typescriptreact': ['/usr/bin/env', 'typescript-language-server', '--stdio'],
\}
let g:LanguageClient_preferredMarkupKind = ['plaintext', 'markdown']
" Format visual selection with '='
set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

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

" Use tab to scroll through auto completions
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Compilers
autocmd BufRead,BufNewFile Cargo.toml,Cargo.lock,*.rs compiler cargo

" Syntax for Helm templates (Go templates inside YAML)
function HelmSyntax()
  set filetype=yaml
  unlet b:current_syntax
  syn include @yamlGoTextTmpl syntax/gotexttmpl.vim
  let b:current_syntax = "yaml"
  syn region goTextTmpl start=/{{/ end=/}}/ contains=@gotplLiteral,gotplControl,gotplFunctions,gotplVariable,goTplIdentifier containedin=ALLBUT,goTextTmpl keepend
  hi def link goTextTmpl PreProc
endfunction
augroup helm_syntax
  autocmd!
  autocmd BufRead,BufNewFile */templates/*.yaml,*/templates/*.tpl call HelmSyntax()
augroup END

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
nnoremap [q :cprevious<cr>zv
nnoremap ]q :cnext<cr>zv
nnoremap [Q :cfirst<cr>zv
nnoremap ]Q :clast<cr>zv
nmap gd <Plug>(lcn-definition)
nmap <leader>ld <Plug>(lcn-definition)
nmap <leader>le <Plug>(lcn-explain-error)
nmap <leader>lf <Plug>(lcn-format)
nmap K <Plug>(lcn-hover)
nmap <leader>lh <Plug>(lcn-hover)
nmap <leader>li <Plug>(lcn-implementation)
nmap <leader>lm <Plug>(lcn-menu)
nmap <leader>lr <Plug>(lcn-rename)
nmap <leader>ls <Plug>(lcn-symbols)
nmap <leader>lt <Plug>(lcn-type-definition)
nmap <leader>lx <Plug>(lcn-references)
nnoremap / /\v

" Load all layered configuration.
for fpath in split(globpath('~/.vim/layers', '**/config.vim'), '\n')
  exe 'source' fpath
endfor
