"     k
" h     l
"   j

" Turn off vi compatibility.(should be set first)
set nocompatible

" TODO
" # rtag
" https://github.com/lyuts/vim-rtags
" https://github.com/Andersbakken/rtags/
" https://skebanga.github.io/rtags-with-cmake-in-spacemacs/

" https://github.com/rprichard/sourceweb

" # java dev
" http://eclim.org/
" http://www.lucianofiandesio.com/vim-configuration-for-happy-java-coding

" # other plugins
" https://github.com/tpope/vim-surround & https://github.com/machakann/vim-sandwich
"
" https://github.com/junegunn/vim-easy-align
"
" # vim-easymotion(like navigation like quitebrowser)
" http://sherifsoliman.com/2016/05/30/favorite-vim-plugins/#vim-easymotion
"
" # for python
" http://sherifsoliman.com/2016/05/30/favorite-vim-plugins/#vim-indent-guides
"
" # better terminal integration
" https://github.com/wincent/terminus

" # Help
" :h tips

" # Depth Navigation
" gf        | goto file under cursor
" gd        | goto local declaration
" gD        | goto global declaration

" # Page Navigation
" C+D       | cursor half page DOWN
" C+U       | cursor half page UP

" # View Navigation
" C+e       | view line DOWN
" C+y       | view line UP

" # Text Navigation
" (         | backward sentence
" )         | forward sentence
" {         | backward paragraph
" }         | forward paragraph

" # Historic position navigation
" C+O       | OLDER position
" C+I       | NEWER position

" # Folding
" zi        | toggle global folding on/off
" za        | toggle fold on current line

" # Spelling
" <f6>          : toggle spell checking
" <leader>z     : word auto suggestions
" zn            : next wrongly spelled
" zp            : previous wrongly spelled

" z=            : list suggestions for word under cursor
" 1z=           : auto select 1 with showing suggestions
" :spellr       : Repeat the replacement done by z=
"
" zg            : add word to dictonary

" # Formatting
" gq            : reformat visual according to textwidth rules
" =             : reformat visual according to indentation

" #
" augroup   - ensures the autocmds are only applied once
" autocmd!  - directive clears all the autocmd's for the current group.
"             useful to avoid duplicated autocmd when file is sourced twice

" # vim-surround
" ds(   - delete surrounding '()'
" cs([  - change surrounding '()' to '[]'
" ysiw] - surround 'iw' with '[]'
" S(    - in Visual mode sorrund selected with '()'

" fold markers are {{{ and }}}
" set foldmethod=marker

" # c
" % jump between {} () []

" # Key Mapping
" prefix:
" (empty):  Normal, Visual+Select, Operator-Pending
" n: Normal only
" v: Visual+Select
" o: Operator-Pending
" x: Visual only
" s: Select only
" i: Insert
" c: Command-line

" *prefix*map     - Define Recursive key mapping
" *prefix*noremap - Define None recursive key mapping
" *prefix*unmap   - Undefine key mapping?

" :*prefix*map - list keymappings

" vim-plug {{{
call plug#begin('~/.vim/plugged')
" # vim        - plug commands
" :PlugInstall - Install plugins
" :PlugUpdate  - Install or update plugins
" :PlugUpgrade - Upgrade vimplug itself
" :PlugStatus  - Check the status of plugins which are loaded and so on
" :PlugDiff

" ###############
" # programming #
" ###############
let programming_ncpp=         {'for':[          'haskell','scala','java','python','vim','bash','sh','xml','markdown','conf','text','zsh','gdb','asm','nasm','make','m4','json','rust','ruby','yaml','sql','go','awk','html','cmake','javascript','ocaml']}
let programming_ncpp_nhaskell={'for':[                    'scala','java','python','vim','bash','sh','xml','markdown','conf','text','zsh','gdb','asm','nasm','make','m4','json','rust','ruby','yaml','sql','go','awk','html','cmake','javascript','ocaml']}
let programming=              {'for':['c','cpp','haskell','scala','java','python','vim','bash','sh','xml','markdown','conf','text','zsh','gdb','asm','nasm','make','m4','json','rust','ruby','yaml','sql','go','awk','html','cmake','javascript','ocaml']}
let programming_nhaskell=     {'for':['c','cpp',          'scala','java','python','vim','bash','sh','xml','markdown','conf','text','zsh','gdb','asm','nasm','make','m4','json','rust','ruby','yaml','sql','go','awk','html','cmake','javascript','ocaml']}
let programming_cpp=          {'for':['c','cpp']}
let programming_haskell=      {'for':'haskell'}
let programming_scala=        {'for':'scala'}

" framework for displaying warnings & errors in source code
Plug 'w0rp/ale',programming
" pane displaying tag information present in current file
Plug 'majutsushi/tagbar',programming_nhaskell
" comment toggle shortcut
Plug 'tomtom/tcomment_vim'
if !has('win32unix') && !has('win64unix')
  " ctags, cscope & global generation
  Plug 'ludovicchabant/vim-gutentags',programming_nhaskell
  " gtags support
  Plug 'bbchung/gtags.vim',programming_nhaskell
endif
" support for different code formatters
Plug 'sbdchd/neoformat'
" exapnds () {} "" '' []
Plug 'Raimondi/delimitMate',programming_nhaskell
" repl based on content from current file
Plug 'metakirby5/codi.vim', { 'on': 'Codi' }
" # vim             command
" Codi [filetype] - activates Codi
" Codi!           - deactivates Codi

" #######
" # cpp #
" #######
" toggle between src/header
Plug 'vim-scripts/a.vim',programming_cpp
" an alternative to color_coded
Plug 'octol/vim-cpp-enhanced-highlight',programming_cpp

" ###########
" # Haskell #
" ###########
" Haskell code completion
Plug 'eagletmt/neco-ghc',programming_haskell
Plug 'dag/vim2hs',programming_haskell

" #########
" # scala #
" #########
" scala support
Plug 'derekwyatt/vim-scala',programming_scala

" ##########
" # syntax #
" ##########
" rfc syntax
Plug 'vim-scripts/rfc-syntax', { 'for': 'rfc' }
" systemd syntax
Plug 'Matt-Deacalion/vim-systemd-syntax'

" ##########
" # text   #
" ##########
Plug 'reedes/vim-pencil', { 'for': 'markdown' }
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
" markdown syntax
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'reedes/vim-colors-pencil'   " http://sherifsoliman.com/2016/05/30/favorite-vim-plugins/#vim-colors-pencil

" ########
" # tmux #
" ########
" Integrate split navigation with tmux
Plug 'christoomey/vim-tmux-navigator'

" ###########
" # general #
" ###########
" colorscheme: railscasts
Plug 'jpo/vim-railscasts-theme'
" if has('win32unix') || has('win64unix')
  " Plug 'tomasiser/vim-code-dark'
" endif
" git integration
Plug 'tpope/vim-fugitive'
" adds commands to surround: XwordX
Plug 'tpope/vim-surround'
" to make repeat(.) work with vim-surround
Plug 'tpope/vim-repeat'
" file explorer
Plug 'scrooloose/nerdtree',{'on':'NERDTreeToggle'}
" fuzzy search (do step does not work)
Plug 'wincent/command-t',{'do':'rake make'}
" colors scope () {}
Plug 'luochen1990/rainbow'
" historic buffer navigation
Plug 'ton/vim-bufsurf'  " TODO ?
" additional *in* support like ci, to change between two ,
Plug 'wellle/targets.vim'
" Centre search result
" Plug 'wincent/loupe'
noremap n nzz
noremap N Nzz

" Visual select * support
Plug 'bronson/vim-visual-star-search'

if has('win32unix') || has('win64unix')
  Plug 'vim-airline/vim-airline'
endif

" unmap some a.vim mappings
Plug '~/.vim/bundle/after',programming_cpp

" turned off in cygwin since these plugins requires compilation
if !has('win32unix') && !has('win64unix')
  " forked YCM for better cpp suggestions
  Plug '~/.vim/bundle/OblitumYouCompleteMe',programming_cpp
  " vanilla YCM
  Plug '~/.vim/bundle/YouCompleteMe',programming_ncpp_nhaskell
else
  Plug 'Rip-Rip/clang_complete',{'do':'make install','for':['cpp','c']}
  let g:clang_close_preview = 1
  set completeopt-=preview
endif

" makes in tmux switching to a vim pane trigger an on-focus event
Plug 'tmux-plugins/vim-tmux-focus-events'
 
Plug 'chrisbra/Colorizer', { 'for': 'vim' }
" :ColorHighlight
"
" let g:colorizer_auto_filetype='vim'
let g:colorizer_colornames_disable = 1

call plug#end()
" }}}

source $HOME/.standardvimrc

colorscheme codedark

" colorscheme {{{
" if has('win32unix') || has('win64unix')
  " wrk {{{
  augroup AutogroupCppVisual
    autocmd!
    " autocmd FileType c,cpp colorscheme codedark
  augroup END

if has('win32unix') || has('win64unix')
  augroup AutogroupCygwinCppVisual
    autocmd!
    autocmd FileType cpp map <silent> <F11> <Esc> :set laststatus=0 <Bar> :AirlineToggle<CR>
  augroup END
endif

  " viasfora rainbow brace 1...N
  " #ff9900   | orange
  " #ff1493   | pink
  " #9acd32   | green
  " #9400d3   | magenta
  " #696969   | grey
  " #4169e1   | dark blue
  " #dc143c   | red
  " #00ced1   | baby blue
  " #008000   | dark green

  " #ff4500 |viasfora orange(return,if...)
  " cterm[bg/fg] - colors used by terminal [background/foregorund]
  " gui[bg/fg]   - color used by gvim or terminal in true-color mode
    " return
    " highlight cStatement guifg=#ff4500
    " if else
    " highlight cConditional guifg=#ff4500
    " for while
    " highlight cRepeat guifg=#ff4500
  "  }}}
" endif

" colorscheme base16
" colorscheme molokai
" colorscheme jellybeans      " ! https://github.com/nanotech/jellybeans.vim
" colorscheme pencil
" badwolf

set background=dark
" }}}

if has('win32unix') || has('win64unix')
  " in cygwin if we save a file not in dos mode outside the 'virtual' linux
  " prompt if it should not be in dos mode instead of the default unix
  " TODO should ignore special buffers like vim msg
  augroup AutogroupCygwin
    autocmd!
    autocmd BufWritePre * if &ff != 'dos' && expand('%:p') =~ "^\/cygdrive\/d\/Worksapce\/" && expand('%:p') !~ "\/Dropbox\/" && input('set ff to dos [y]') == 'y' | setlocal ff=dos | endif
  augroup END
endif

" Goyo {{{
augroup AutogroupGoyo
  autocmd!
  autocmd FileType markdown,mail,text,gitcommit map <silent> <F11> <Esc> :Goyo <Bar> :TogglePencil <CR>
augroup END
" }}}
"

" Generic Writing {{{
" let g:languagetool_jar  = '/opt/languagetool/languagetool-commandline.jar'
" }}}

" Pencil {{{
" hardwrap - vim adds newlines character when line is to long
" softwrap - vim presents long lines wrapped over multiple lines
" TODO
" let g:pencil#wrapModeDefault = 'hard'
" augroup AutogroupPencil
"   autocmd!
"   autocmd FileType markdown,mkd call pencil#init()
"   autocmd FileType text         call pencil#init({'wrap': 'hard'})
"   autocmd FileType gitcommit         call pencil#init({'wrap': 'hard'})
" augroup END

" affects HardPencil only - blacklist formatting for text with tagged by these syntax
" highlight group
let g:pencil#autoformat_config = {
      \   'markdown': {
      \     'black': [
      \       'htmlH[0-9]',
      \       'markdown(Code|H[0-9]|Url|IdDeclaration|Link|Rule|Highlight[A-Za-z0-9]+)',
      \       'markdown(FencedCodeBlock|InlineCode)',
      \       'mkd(Code|Rule|Delimiter|Link|ListItem|IndentCode)',
      \       'mmdTable[A-Za-z0-9]*',
      \     ],
      \     'white': [
      \      'markdown(Code|Link)',
      \     ],
      \   },
      \ }
" }}}

" Codi {{{
let g:codi#interpreters = {
      \ 'python': {
      \ 'bin': 'python3',
      \ },
      \ }
" }}}

" Tagbar {{{
let g:tagbar_show_linenumbers = 1 " display line number in the tagbar pane
" }}}

" vim2hs {{{
let g:haskell_conceal_wide = 1
" 0 = disable all conceals, including the simple ones like
" lambda and composition
" let g:haskell_conceal              = 1

" 0 = disable concealing of "enumerations": commatized lists like
" deriving clauses and LANGUAGE pragmas,
" otherwise collapsed into a single ellipsis
" let g:haskell_conceal_enumerations = 1

" }}}

" vim-scala {{{
let g:scala_use_default_keymappings = 0
" }}}

" rainbow scope {{{
" activate rainbow scope higlight
let g:rainbow_active = 1

"\ 'guifgs': ['darkorange3', 'seagreen3', 'deepskyblue', 'darkorchid3', 'forestgreen', 'lightblue', 'hotpink', 'mistyrose1'],
" \ 'operators': '_[\,\+\*\-\&\^\!\.\<\>\=\|\?]_',
", 'lightmagenta'
  " #ff9900   | orange
  " #ff1493   | pink
  " #9acd32   | green
  " #9400d3   | magenta
  " #696969   | grey
  " #4169e1   | dark blue
  " #dc143c   | red
  " #00ced1   | baby blue
  " #008000   | dark green
let g:rainbow_conf =
\ {
\ 'ctermfgs': ['lightblue', 'red', 'cyan', 'darkgreen'],
\ 'guifgs': ['#ff9900','#ff1493','#9acd32'],
\ 'operators': '_[\,\-\<\>\.|\*]_'
\ }

" }}}

" DelimitMate {{{
let delimitMate_expand_cr = 1
" }}}

" ALE {{{
" :ALEInfo - current settings

"'clang', 'clangcheck', 'cpplint','cppcheck', 'clangtidy'
let g:ale_linters = {
\   'cpp': ['g++','cppcheck'],
\   'c': ['gcc','cppcheck'],
\}

let g:ale_cpp_gcc_options="-std=c++17 -Wall -Wextra -Wpedantic -Iexternal -I../external -I../external/googletest/googletest -Iexternal/googletest/googletest -Werror-pointer-arith"

" }}}

" YouCompleteMe {{{
" YouCompleteMe - Install
" cd ~/.vim/bundle/YouCompleteMe;./install.sh --clang-completer

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

" using Ycm to navigate
" https://github.com/Valloric/YouCompleteMe#goto-commands
map <silent> <F3> <esc>:YcmCompleter GoTo<CR>

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
augroup AutogroupNerdTree
  autocmd!
  autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
augroup END

function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

" }}}

" gdb {{{
" function! JobCallback(self, data) abort
"   echom string([a:self, a:data])
" endfunction
function! GDBBreak()
  let l:command1 = "echo 'break \"" . bufname("%") . ":" .line(".") . "\"' >> .gdb_breakpoints"
  let l:command2 = "cat .gdb_breakpoints | sort | uniq > .gdb_breakpoints"

  if v:version < 800
      silent execute "!" . l:command1
      silent execute "!" . l:command2
      execute ':redraw!'
    return
  endif
  let l:shell_command = [&shell, &shellcmdflag, l:command1 . "&&" . l:command2]
  let j = job_start(l:shell_command) ", {'out_cb': 'JobCallback', 'exit_cb': 'JobCallback'}
endfunction

command! GDBBreak :call GDBBreak()
augroup AutogroupGDB
  autocmd!
  autocmd FileType c,cpp,objc nnoremap <leader>j <esc>:GDBBreak<CR>
augroup END
" }}}

" vim-cpp-enhanced-highlight {{{
let g:cpp_class_scope_highlight = 0           " Highlighting of class scope
let g:cpp_experimental_template_highlight = 0 " Highlighting of template functions
" let g:cpp_member_variable_highlight = 1
" }}}


" neoformat {{{
let g:neoformat_enabled_cpp = ['clangformat']

augroup AutogroupNeoformat
  autocmd!
  autocmd FileType c,cpp nnoremap <buffer><leader>f <esc>:Neoformat<CR>
  autocmd FileType c,cpp vnoremap <buffer><leader>f <esc>:Neoformat<CR>
augroup END
" }}}

" format json {{{
function! FormatJson()
  :mark o
  " format json file using 2 space indentation
  exec "%!python ~/dotfiles/lib/json_format.py 2"
  :normal `o
endfunction!
command! FormatJson :call FormatJson()

augroup AutogroupFormatJson
  autocmd!
  autocmd FileType json nnoremap <buffer><leader>f <esc>:FormatJson<CR>
augroup END
" }}}

" debug syntax {{{
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

command! SynStack :call SynStack()
map <F7> :SynStack<CR>
" }}}

" ctags {{{
" ctags - look in the current directory for 'tags',
" and work up the tree towards root until one is found
set tags=./.tags;/

" open tag
" map <silent> <F3> <c-]>
" open tag in vertical split
map <silent> <leader><F3> <a-]>
" previous
" map <silent> <A-Left> <c-t>
" }}}

" TComment {{{
nmap <leader>c <esc>:TComment<CR>
nmap <leader>= <esc>:TCommentBlock<CR>

" Tcomment visual
vmap <leader>c :TComment<CR>
vmap <leader>= :TCommentBlock<CR>
" }}}

" tagbar {{{
nmap <silent> <F10> <esc>:TagbarToggle<CR>
imap <silent> <F10> <ESC>:TagbarToggle<CR>
cmap <silent> <F10> <ESC>:TagbarToggle<CR>
" }}}

" nerdtree {{{
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

" }}}

" CommandT {{{
noremap <silent> <leader>r <Esc>:CommandT<CR>
" noremap <silent> <leader>O <Esc>:CommandTFlush<CR>
noremap <silent> <leader>m <Esc>:CommandTBuffer<CR>
noremap <silent> <leader>. <esc>:CommandTTag<cr>

" }}}

" a.vim {{{
augroup AugroupAVIM
  autocmd!
  " toggle between header and source
  autocmd FileType c,cpp,objc map <silent> <F2> :A<CR>
  " open source or header in vertical split
  autocmd FileType c,cpp,objc map <silent> <leader><F2> :AV<CR>

augroup END
" }}}

" Statusline {{{
" Powerline
" set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
set rtp+=/usr/lib/python2.7/site-packages/powerline/bindings/vim
"
" Always show statusline
set laststatus=2
" }}}

" gutentags {{{
let g:gutentags_modules=['ctags', 'gtags_cscope']
let g:gutentags_ctags_executable="ctags"
let g:gutentags_ctags_tagfile=".tags"
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

" }}}

