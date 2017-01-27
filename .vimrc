set nocompatible                  " Turn off vi compatibility.(should be set first)
" pathogen plugin manager
execute pathogen#infect()
execute pathogen#helptags()

"
if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
  set t_Co=256
  " let g:solarized_termcolors = 256
endif

" theme
syntax enable                     " Highlight the syntax.
" colorscheme twilighted
" if has('gui_running')
"     set background=light
" let g:solarized_contrast="high"
" else
"     set background=dark
" endif 

" Buffer surfer - a buffer stack of recently used buffers
let g:BufSurfIgnore = "__TAGBAR__,help.txt,NERD_tree_*"
map <silent> <A-Left> <esc>:BufSurfBack<cr>
map <silent> <A-Right> <esc>:BufSurfForward<cr>
" Tagbar
let g:tagbar_show_linenumbers = 1 " display line number in the tagbar pane

" general
set ttyfast                      " Faster redraw
set wildmode=longest:full,full   " bash like command completion when tab
set showcmd                      " Show incomplete commands as I type
set wildmenu                     " Show command completion with tab
set lazyredraw                   " Draw more judiciously

" set cursorline                    " Higlight current line
let mapleader = "\<Space>"        " map leader to  <space>
set relativenumber                " relative line numbers
set number                        " both relative and absolute number
" set mouse=a                       " Enables scrolling in the terminal.

" search
set incsearch                     " search wile you type
set smartcase                     " Case insensitive search, except when capital letters are used.
set ignorecase                    " ignore case when searching
set hls                           " highligt search?

" language
set spelllang=en_gb,sv            " Specify the spell checking language.
set nospell                       " Disable spell checking by default.
"
if has('vim_starting')
  set fileencoding=utf-8
  scriptencoding utf-8
  set encoding=utf-8 nobomb
endif

"
set nowrap        " don't wrap lines
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set shiftwidth=2  " number of spaces to use for autoindenting
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
"
set ruler                         " Display the ruler
" Tab config
set tabstop=2
set shiftwidth=2
set expandtab

"
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting

" file type specific indentention support 
filetype plugin on                " Enable file type plug-ins
filetype indent plugin on
filetype on                       " Enable file type detection
set smartindent                   " smart indentation
" vim2hs
let g:haskell_conceal_wide = 1

" vim-scala
let g:scala_use_default_keymappings = 0

" active rainbow scope higlight 
let g:rainbow_active = 1

"\ 'guifgs': ['darkorange3', 'seagreen3', 'deepskyblue', 'darkorchid3', 'forestgreen', 'lightblue', 'hotpink', 'mistyrose1'],
" \ 'operators': '_[\,\+\*\-\&\^\!\.\<\>\=\|\?]_',
", 'lightmagenta'
let g:rainbow_conf =
\ {
\ 'ctermfgs': ['lightblue', 'red', 'cyan', 'darkgreen'],
\ 'operators': '_[\,\-\<\>\.|]_'
\ }

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" syntastic conf
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height=5 " height of error split

"
" let g:syntastic_error_symbol = '❌'
" let g:syntastic_style_error_symbol = '⁉️'
" let g:syntastic_warning_symbol = '⚠️'
" let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

"syntastic c++
let g:syntastic_cpp_compiler = 'gcc'
" let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = "-std=c++14 -Wall -Wextra -Wpedantic"
" let g:syntastic_cpp_compiler_options = ' -std=c++14 -stdlib=libc++'
let g:syntastic_cpp_check_header = 1
"let g:syntastic_cpp_checkers=["clang_check","g++","cpp_check"]
let g:syntastic_cpp_checkers=["gcc","cppcheck","cpplint"]
let g:syntastic_cppcheck_config_file="~/.syntastic_cppcheck_config"
" java remove because it runs mvn wich is realy slow
let g:syntastic_java_checkers=['']
let g:syntastic_json_checkers=['jsonlint']
let g:syntastic_python_checkers = ['python']
" YouCompleteMe
let g:ycm_show_diagnostics_ui = 0
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_confirm_extra_conf = 0                  " disable confirm
" let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra'

hi clear SpellBad
hi SpellBad cterm=underline

" color_coded
let g:color_coded_enabled = 1
let g:color_coded_filetypes = ['c', 'cpp', 'objc']
let g:rehash256 = 1

" clang format
let g:clang_format#style_options = {
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "Cpp11",
            \ "AllowShortFunctionsOnASingleLine" : "None",
            \ "BasedOnStyle" : "LLVM"}
" clang format - map to <Leader>cf in C++ code(\cf)
autocmd FileType c,cpp,objc,javascript,java,typescript nnoremap <buffer><Leader>f <esc>:<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc,javascript,java,typescript vnoremap <buffer><Leader>f <esc>:ClangFormat<CR>

" format json
function! FormatJson()
  " format json file using 2 space indentation
  exec "%!python ~/dotfiles/lib/json_format.py 2"
endfunction!
command! FormatJson :call FormatJson()
autocmd FileType json nnoremap <buffer><leader>f <esc>:FormatJson<CR>

" ctags - look in the current directory for 'tags',
" and work up the tree towards root until one is found
set tags=./.tags;/
" open tag
map <silent> <F3> <c-]>
" open tag in vertical split
map <silent> <leader><F3> <a-]>
" previous 
" map <silent> <A-Left> <c-t>

" TComment
nmap <leader>c :TComment<CR>
nmap <leader>= :TCommentBlock<CR>

" Tcomment visual
vmap <leader>c :TComment<CR>
vmap <leader>= :TCommentBlock<CR>

" tagbar
nmap <silent> <F10> :TagbarToggle<CR>
imap <silent> <F10> <ESC>:TagbarToggle<CR>
cmap <silent> <F10> <ESC>:TagbarToggle<CR>

" nerdtree
map <silent> <F8> :NERDTreeToggle<CR>
imap <silent> <F8> <ESC>:NERDTreeToggle<CR>
cmap <silent> <F8> <ESC>:NERDTreeToggle<CR>
let NERDTreeIgnore = [
    \ '\.pyc$',
    \ '\.class$',
    \ '\.cm\(x\(a\)\?\|i\|t\)$',
    \ '\.sp\(o\|i\)t$',
    \ '\.o\(\(pt\|mc\)\)\=$',
\ '\.annot$'] " Ignores

let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden=1  " show hidden dotfiles

" CommandT
noremap <silent> <leader>r <Esc>:CommandT<CR>
" noremap <silent> <leader>O <Esc>:CommandTFlush<CR>
noremap <silent> <leader>m <Esc>:CommandTBuffer<CR>
noremap <silent> <leader>. :CommandTTag<cr>

" ignore files in filefinder
let g:CommandTWildIgnore='*.class,*.cache,*.part,*.exe,*.zip,*.tar,*.tar.gz,*.jar,*.so,*.gif,*.pdf,*.pyc'

" vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1 " Highlighting of class scope
let g:cpp_experimental_template_highlight = 1 " Highlighting of template functions

":CommandTMRU

" Alias
" set pastetoggle=<F2>

" pastetoggle
set pastetoggle=<f5>
" Alternative save
nnoremap <silent> <leader>w <esc>:wa<CR>
" Alternative quit
nnoremap <silent> <leader>q <esc>:q<CR>
" map å to page up
map <silent> å <PageUp>
" map ä to page down
map <silent> ä <PageDown>

map <silent> <leader>, <esc>:noh<CR>

" resize split
map <silent> <leader>- <esc>:vertical resize -5<CR>
map <silent> <leader>+ <esc>:vertical resize +5<CR>
" navigate between splits
" pane Left
map <silent> <leader><Left> <C-W><Left>
" pane Right
map <silent> <leader><Right> <C-W><Right>
" pane Up
map <silent> <leader><Up> <C-W><Up>
" pane Down
map <silent> <leader><Down> <C-W><Down>

" Create vertical pane
nnoremap <leader>s <esc>:vsplit<enter>
" Create horizontal pane
nnoremap <leader>h <esc>:sp<enter>
" Create tab
nnoremap <leader>e <esc>:tabedit<enter>

" new line above and below without entering insert mode
map <silent> <leader>o o<esc>
map <silent> <leader>O O<esc>

map <silent> ö <C-D>
map <silent> Ö <C-U>

" pane navigation
map <silent> <leader>1 <esc>1gt
map <silent> <leader>2 <esc>2gt
map <silent> <leader>3 <esc>3gt
map <silent> <leader>4 <esc>4gt
map <silent> <leader>5 <esc>5gt
map <silent> <leader>6 <esc>6gt
map <silent> <leader>7 <esc>7gt
map <silent> <leader>8 <esc>8gt
map <silent> <leader>9 <esc>9gt

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

" Get rid of nasty lag on ESC (timeout and ttimeout seem useless) sp??
au InsertEnter * set timeoutlen=1
au InsertLeave * set timeoutlen=1000
set timeoutlen=1000 ttimeoutlen=0

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

" ack
" Do not auto open first match
cnoreabbrev Ack Ack!
" a.vim
" toggle between header and source
autocmd FileType c,cpp,objc,h map <silent> <F2> :A<CR>
" open source or header in vertical split
autocmd FileType c,cpp,objc,h map <silent> <leader><F2> :AV<CR>

" Powerline
set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
" Always show statusline
set laststatus=2

"
let g:gutentags_modules=['ctags', 'gtags_cscope']
let g:gutentags_ctags_executable="ctags"
let g:gutentags_tagfile=".tags"
let g:gutentags_generate_on_missing=1
let g:gutentags_background_update=1

" let g:gutentags_ctags_executable_cpp="ctag"

let g:gutentags_project_info=[]
call add(g:gutentags_project_info, {'type': 'python', 'file': 'setup.py'})
call add(g:gutentags_project_info, {'type': 'ruby', 'file': 'Gemfile'})
call add(g:gutentags_project_info, {'type': 'haskell', 'glob': '*.cabal'})
call add(g:gutentags_project_info, {'type': 'haskell', 'file': 'stack.yaml'})

" gtags
let g:gutentags_gtags_executable="gtags"
let g:gutentags_gtags_cscope_executable = 'gtags-cscope'
let g:gutentags_auto_add_gtags_cscope = 1
