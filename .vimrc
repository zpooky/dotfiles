
if has('win32') || has('win64')
  source D:\cygwin64\home\fredrik\.standardvimrc

  let g:python_host_prog = "C:\\Python27\\python.exe"
  let g:python3_host_prog = "C:\\Python36\\python.exe"
else
  source $HOME/.standardvimrc
endif

call plug#begin('~/.vim/plugged')
source $HOME/.config/nvim/plug.vim

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
