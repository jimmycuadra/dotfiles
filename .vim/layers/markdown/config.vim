autocmd BufNewFile,BufReadPost *.md set filetype=markdown

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
