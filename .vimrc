
if has('win32') || has('win64')
  source D:\cygwin64\home\fredrik\.standardvimrc

  let g:python_host_prog = "C:\\Python27\\python.exe"
  let g:python3_host_prog = "C:\\Python36\\python.exe"
else
  source $HOME/.standardvimrc
endif

call plug#begin('~/.vim/plugged')
source $HOME/.config/nvim/plug.vim

" markdown {{{
Plug 'tpope/vim-markdown'
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'c', 'dts', 'xml', 'strace', 'zsh=sh', 'cpp', 'vim', 'lua', 'make', 'ld', 'asm', 'json', 'diff', 'java', 'scala', 'haskell', 'sql', 'javascript']
let g:markdown_syntax_conceal = 0
let g:markdown_minlines = 9000
let g:markdown_recommended_style=0
" }}}

" {{{
if !has("patch-8.2.2345")
  " makes in tmux switching to a vim pane trigger an on-focus event
  Plug 'tmux-plugins/vim-tmux-focus-events'
endif
" }}}

call plug#end()


" {{{
colorscheme codedark
set background=dark
" }}}
