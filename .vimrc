" Turn off vi compatibility.(should be set first)
set nocompatible

"
if has('vim_starting')
  set fileencoding=utf-8
  scriptencoding utf-8
  set encoding=utf-8 nobomb
endif

" pathogen plugin manager
execute pathogen#infect()

let g:pathogen_disabled = []
call add(g:pathogen_disabled, 'YouCompleteMe')

execute pathogen#helptags()

"
if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
  set t_Co=256
  " let g:solarized_termcolors = 256
endif

" theme
syntax enable                     " Highlight the syntax.
" autocmd BufEnter * colorscheme default
autocmd FileType c,cpp,gitconfig colorscheme railscasts
" autocmd FileType vim    colorscheme obsidian            " works for vimrc atleast
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

" command(:)
set wildmode=longest:full,full   " bash like command(:) completion when tab
set wildmenu                     " Show command(:) completion with tab

" note: debug set with "set list?" ?: means print current value
set list                              " show special chars, such as tab: eol: trail: extends: nbsp:
" chars to show for blank characters
set listchars=tab:·»
set listchars+=eol:¬
set listchars+=trail:·
set showbreak=↪\                    " useful indication of wrapping

" general
set ttyfast                      " Faster redraw
" don't bother updating screen during macro playback
set lazyredraw
set showcmd                      " Show incomplete vim motions as I type

" set cursorline                    " Higlight current line
autocmd FileType c,cpp set cursorline
let mapleader = "\<Space>"        " map leader to  <space>
set relativenumber                " relative line numbers
set number                        " both relative and absolute number
" set mouse=a                       " Enables scrolling terminal.(mouse mode)

" search
set incsearch                     " search wile you type
set smartcase                     " Case insensitive search, except when capital letters are used.
set ignorecase                    " ignore case when searching
set hls                           " highligt search?

" Navigation captial H/L goto extreme Right/Left
noremap H _
noremap L g_

" Spelling
"
" gq            : reformat visual
" ctrl-n        : Next word suggestion
" ctrl-p        : Previous word suggestion
"
" z=            : list suggestions
" 1z=           : auto select 1 with showing suggestions
" :spellr       : Repeat the replacement done by z=
"
" ]s            : next wrongly spelled
" {s            : previous
" zg            : add word to dictonary

" bindings
map <leader>ss :setlocal spell!<CR>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>sq z=

" underline wrongly spelled words
hi clear SpellBad
hi SpellBad cterm=underline

set spelllang=en_gb               " Specify the spell checking language.
set nospell                       " Disable spell checking by default.
set dictionary+=/usr/share/dict/words
au FileType gitcommit,md,text,mail set textwidth=80
au FileType gitcommit,md,text,mail set colorcolumn=-2 " display bar at textwidth
au FileType gitcommit,md,text,mail set complete+=kspell
au FileType gitcommit,md,mail set spell             " turn on spelling for thease types

set nowrap                        " don't wrap lines
set backspace=indent,eol,start    " allow backspacing over everything in insert mode
set shiftwidth=2                  " number of spaces to use for autoindenting
set smarttab                      " insert tabs on the start of a line according
                                  " to shiftwidth, not tabstop
"
set ruler                         " Display the ruler
" Tab config
set tabstop=2
set shiftwidth=2
set expandtab                     " when emitting tab convert to space

"
set autoindent                    " always set autoindenting on
set copyindent                    " copy the previous indentation on autoindenting
set smartindent                   " smart indentation
"
filetype on                       " Enable file type detection
filetype plugin on                " Enable file type plug-ins
filetype indent plugin on         " file type specific indentention support 

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
let g:ycm_confirm_extra_conf = 0                        " disable confirm of project specific ycm conf

let g:ycm_autoclose_preview_window_after_completion = 0 " do not directly close prototype window
let g:ycm_autoclose_preview_window_after_insertion = 1  " close it when I exit insert mode.
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" " ycm ultisnip integration
" " YCM + UltiSnips works like crap
" " https://www.youtube.com/watch?v=WeppptWfV-0
" let g:ycm_use_ultisnips_completer = 1
" let g:ycm_key_list_select_completion=[]
" let g:ycm_key_list_previous_completion=[]
" let g:UltiSnipsExpandTrigger = '<Tab>'
" let g:UltiSnipsJumpForwardTrigger = '<Tab>'
" let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
"
" let g:UltiSnipsMappingsToIgnore = ['autocomplete']
"
" let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
" let g:ycm_key_list_accept_completion = ['<C-y>']
"
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
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>f <esc>:<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>f <esc>:ClangFormat<CR>

" format json
function! FormatJson()
  :mark o
  " format json file using 2 space indentation
  exec "%!python ~/dotfiles/lib/json_format.py 2"
  :normal `o
endfunction!
command! FormatJson :call FormatJson()
autocmd FileType json nnoremap <buffer><leader>f <esc>:FormatJson<CR>

" format python
let g:formatter_yapf_style = 'chrome'

" vim-autoformat language formatters
autocmd FileType java,python,html,css,markdown,haskell,xml nnoremap <buffer><leader>f :Autoformat<CR>

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
nmap <leader>c <esc>:TComment<CR>
nmap <leader>= <esc>:TCommentBlock<CR>

" Tcomment visual
vmap <leader>c :TComment<CR>
vmap <leader>= :TCommentBlock<CR>

" tagbar
nmap <silent> <F10> <esc>:TagbarToggle<CR>
imap <silent> <F10> <ESC>:TagbarToggle<CR>
cmap <silent> <F10> <ESC>:TagbarToggle<CR>

" nerdtree
map <silent> <F8> <esc>:NERDTreeToggle<CR>
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
let NERDTreeShowHidden = 1  " show hidden dotfiles

" CommandT
noremap <silent> <leader>r <Esc>:CommandT<CR>
" noremap <silent> <leader>O <Esc>:CommandTFlush<CR>
noremap <silent> <leader>m <Esc>:CommandTBuffer<CR>
noremap <silent> <leader>. <esc>:CommandTTag<cr>

" ignore files in filefinder
let g:CommandTWildIgnore='*.class,*.cache,*.part,*.exe,*.zip,*.tar,*.tar.gz,*.jar,*.so,*.gif,*.pdf,*.pyc'

" vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1 " Highlighting of class scope
let g:cpp_experimental_template_highlight = 1 " Highlighting of template functions

":CommandTMRU

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

" Alternative Moving around splits with the leader key
" nmap <silent> <leader>h :wincmd h<CR> " TODO conflict with split horizontal
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>l :wincmd l<CR>

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
"
set autoread            " auto reload after outside changes

" Get rid of nasty lag on ESC (timeout and ttimeout seem useless) sp??
au InsertEnter * set timeoutlen=1
au InsertLeave * set timeoutlen=1000
set timeoutlen=1000 ttimeoutlen=0

" Stop that stupid window from popping up
map q: <esc>:q

"
au BufNewFile,BufRead *.md set ft=markdown
au FileType markdown,python set ts=2 sw=2 expandtab

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
" Do not auto open first match(Ack! instead of Ack)
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
