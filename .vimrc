" pathogen plugin manager
execute pathogen#infect()

" Tagbar
let g:tagbar_show_linenumbers = 1 " display line number in the tagbar pane

" general
" set cursorline                    " Higlight current line
let mapleader = "\<Space>"        " map leader to  <space>
set relativenumber                " relative line numbers
set number                        " both relative and absolute number
set incsearch                     " search wile you type
set ic
set hls

" language
set spelllang=en_us               " Specify the spell checking language.
set nospell                       " Disable spell checking by default.

" theme
syntax on                         " Highlight the syntax.
" if has('gui_running')
"     set background=light
"let g:solarized_contrast="high"
" else
"     set background=dark
" endif 
" colorscheme solarized
" let g:solarized_termcolors = 256
" set t_Co=256

"
set ruler                         " Display the ruler.
" Tab config
set tabstop=2
set shiftwidth=2
set expandtab

" file type specific indentention support 
filetype plugin on                " Enable file type plug-ins
filetype on                       " Enable file type detection
set smartindent                   " smart indentation
" vim2hs
let g:haskell_conceal_wide = 1

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" syntastic conf
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"syntastic c++
let g:syntastic_cpp_compiler = 'gcc'
" let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = "-std=c++14 -Wall -Wextra -Wpedantic"
" let g:syntastic_cpp_compiler_options = ' -std=c++14 -stdlib=libc++'
let g:syntastic_cpp_check_header = 1
"let g:syntastic_cpp_checkers=["clang_check","g++","cpp_check"]
let g:syntastic_cpp_checkers=["gcc","cppcheck","cpplint"]
let g:syntastic_cppcheck_config_file="~/.syntastic_cppcheck_config"

" YouCompleteMe
let g:ycm_show_diagnostics_ui = 0
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_confirm_extra_conf = 0                  " disable confirm

hi clear SpellBad
hi SpellBad cterm=underline

" clang format
let g:clang_format#style_options = {
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "Cpp11",
            \ "AllowShortFunctionsOnASingleLine" : "None",
            \ "BasedOnStyle" : "LLVM"}
" clang format - map to <Leader>cf in C++ code(\cf)
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>f :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>f :ClangFormat<CR>

" ctags - look in the current directory for 'tags',
" and work up the tree towards root until one is found
set tags=./.tags;/
" open tag
map <silent> <F3> <c-]>
" open tag in vertical split
map <silent> <leader><F3> <a-]>
" previous 
map <silent> <A-Left> <c-t>

" TComment
nmap <leader>c :TComment<CR>
nmap <leader>= :TCommentBlock<CR>

" Tcomment visual
vmap <leader>c :TComment<CR>
vmap <leader>= :TCommentBlock<CR>

" tagbar
nmap <silent> <F8> :TagbarToggle<CR>
imap <silent> <F8> <ESC>:TagbarToggle<CR>
cmap <silent> <F8> <ESC>:TagbarToggle<CR>

" nerdtree
map <silent> <F10> :NERDTreeToggle<CR>
imap <silent> <F10> <ESC>:NERDTreeToggle<CR>
cmap <silent> <F10> <ESC>:NERDTreeToggle<CR>

let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" CommandT
noremap <silent> <leader>r <Esc>:CommandT<CR>
" noremap <silent> <leader>O <Esc>:CommandTFlush<CR>
noremap <silent> <leader>m <Esc>:CommandTBuffer<CR>
noremap <silent> <leader>. :CommandTTag<cr>

":CommandTMRU

" Alias
" set pastetoggle=<F2>

" Alternative save with <leader>+w
nnoremap <leader>w :wa<CR>
" map å to page up
map <silent> å <PageUp>
" map ä to page down
map <silent> ä <PageDown>

" navigate between panes
" pane Left
map <silent> <leader><Left> <C-W><Left>
" pane Right
map <silent> <leader><Right> <C-W><Right>
" pane Up
map <silent> <leader><Up> <C-W><Up>
" pane Down
map <silent> <leader><Down> <C-W><Down>
" new line above and below without entering insert mode
map <silent> <leader>o o<esc>
map <silent> <leader>O O<esc>

" insert character(space+*char*)
" nmap <Space> i_<Esc>r " Need to have another than space it is now the leadr
" nmap <S-Enter> O<Esc>j

" YouCompleteMe - Install
" cd ~/.vim/bundle/YouCompleteMe;./install.sh --clang-completer

"
set history=1000         " remember more commands and search history
set undolevels=1000      " use many levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title

"
set novisualbell         " don't beep
set noerrorbells         " don't beep

"
set nobackup            " no bak
set noswapfile          " no swap
set autoread            " auto reload when changes

" Stop that stupid window from popping up
map q: :q

"
au BufNewFile,BufRead *.md set ft=markdown
au FileType markdown,python set ts=2 sw=2 expandtab
au FileType gitcommit,md,txt set spell      " turn of spelling for thease types

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" vim-autotool
let g:autotagTagsFile=".tags" " the ctag file name
" a.vim
" toggle between header and source
autocmd FileType c,cpp,objc,h map <silent> <F2> :A<CR>
" open source or header in vertical split
autocmd FileType c,cpp,objc,h map <silent> <leader><F2> :AV<CR>
