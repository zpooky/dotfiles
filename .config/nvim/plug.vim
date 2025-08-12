"     k
" h     l
"   j


" :PlugUpdate

" https://github.com/rprichard/sourceweb

" # java dev
" http://eclim.org/
" http://www.lucianofiandesio.com/vim-configuration-for-happy-java-coding

" # other plugins
" https://github.com/machakann/vim-sandwich
"
" # alignment
" https://github.com/junegunn/vim-easy-align
" vim-lion plugin is used to align text around a chosen character.
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
" zg            : to add word to own spellfile

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

" # Terminal Options
" :h termina-options

" vim-plug {{{
let programming_ncpp=         {'for':[          'haskell','scala','java','python','vim','bash','sh','xml','markdown','conf','text','zsh','gdb','asm','nasm','make','m4','json','rust','ruby','yaml','sql','go','awk','html','cmake','javascript','ocaml']}
let programming_ncpp_nhaskell={'for':[                    'scala','java','python','vim','bash','sh','xml','markdown','conf','text','zsh','gdb','asm','nasm','make','m4','json','rust','ruby','yaml','sql','go','awk','html','cmake','javascript','ocaml']}
let programming=              {'for':['c','cpp','haskell','scala','java','python','vim','bash','sh','xml','markdown','conf','text','zsh','gdb','asm','nasm','make','m4','json','rust','ruby','yaml','sql','go','awk','html','cmake','javascript','ocaml']}
let programming_nhaskell=     {'for':['c','cpp',          'scala','java','python','vim','bash','sh','xml','markdown','conf','text','zsh','gdb','asm','nasm','make','m4','json','rust','ruby','yaml','sql','go','awk','html','cmake','javascript','ocaml']}
let programming_cpp=          {'for':['c','cpp']}
let programming_haskell=      {'for':'haskell'}
let programming_scala=        {'for':'scala'}
" }}}

" rainbow scope {{{
if 1
" colors scope () {}
Plug 'luochen1990/rainbow'

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
      \ 'operators': '_[\,\-\<\>\.|\*]_',
      \	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
      \	'separately': {
      \   'sh': {
      \     'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
      \   },
      \   'make': {
      \     'parentheses':[['\(^\|\s\)\(ifeq\|ifneq\|ifdef\|ifndef\)\($\|\s\)','_\(^\|\s\)\(endif\|else ifeq\|else ifneq\|else ifdef\|else ifndef\|else\)\($\|\s\)_','\(^\|\s\)endif\($\|\s\)']],
      \   },
      \   'fortran': {
      \     'parentheses':[['\(^\|\s\)\(\#if\|\#ifdef\|\#ifndef\)\($\|\s\)','_\(^\|\s\)\(\#endif\|\#elif\|\#else\)\($\|\s\)_','\(^\|\s\)\#endif\($\|\s\)'], ['\(^\|\s\)\#for\($\|\s\)','\(^\|\s\)\#endfor\($\|\s\)']],
      \   },
      \   'vim': {
      \     'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
      \   },
      \   'c': {
      \     'parentheses':[['\(\#ifdef\|\#ifndef\|\#if\)','\#endif'], 'start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
      \   },
      \ }
      \ }

" NOTE: fortran is dummy used for *.fpp files
endif
" }}}

" coc.vim {{{
if 0
if executable('cclsx')

function! s:SpF3Unmap()
  if maparg('<f3>')
    unmap <f3>
  endif
endfunc

  " https://github.com/neoclide/coc.nvim#example-vim-configuration
  Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}, 'branch': 'release', 'for': ['cpp','sh','rust','go','zsh','vim','python','java','lua']}
  augroup AugroupCocCPP
    autocmd!

    autocmd FileType cpp :call s:SpF3Unmap()
    autocmd FileType cpp nmap <buffer> <silent> <f3> <Plug>(coc-definition)

    autocmd FileType cpp nmap <buffer> <silent> gd <Plug>(coc-definition)
    autocmd FileType cpp nmap <buffer> <silent> gy <Plug>(coc-type-definition)
    autocmd FileType cpp nmap <buffer> <silent> gi <Plug>(coc-implementation)
    autocmd FileType cpp nmap <buffer> <silent> gr <Plug>(coc-references)
    autocmd FileType cpp map <buffer> <silent> <F4> <Plug>(coc-rename)

    autocmd FileType cpp inoremap <silent><expr> <c-n>
                                \ coc#pum#visible() ? coc#pum#next(1):
                                \ CheckBackspace() ? "\<Tab>" :
                                \ coc#refresh()
    autocmd FileType cpp inoremap <expr><c-p> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  augroup END
else
  Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}, 'branch': 'release', 'for': ['sh','rust','go','zsh','vim','python','java','lua']}
endif

" apt install python3-venv
let g:coc_global_extensions = [ 'coc-css', 'coc-json', 'coc-yaml', 'coc-xml', 'coc-java', 'coc-rls', 'coc-rust-analyzer', 'coc-go', 'coc-sql', 'coc-vimlsp', 'coc-jedi', 'coc-lua']
" https://github.com/josa42/coc-go
" https://github.com/neoclide/coc-java

" https://kimpers.com/vim-intelligent-autocompletion/

" :CocInfo
" :CocConfig
" :CocInstall

" TODO checkout
" " Smaller updatetime for CursorHold & CursorHoldI
" set updatetime=300
" don't give |ins-completion-menu| messages.
" set shortmess+=c

" set updatetime=300
" au CursorHold * sil call CocActionAsync('highlight')
" au CursorHoldI * sil call CocActionAsync('showSignatureHelp')

augroup AugroupCoc
  autocmd!
  autocmd FileType sh,rust,go,zsh,vim,scala,python,java,lua unmap <f3>
  " autocmd FileType cpp,sh,c,rust,go,zsh,vim,scala,python,java unmap gd
  autocmd FileType sh,rust,go,zsh,vim,scala,python,java,lua nmap <silent> <F3> <Plug>(coc-definition)
  " autocmd FileType cpp,sh,c,rust,go,zsh map <silent> <leader><F3> :tabedit % | call CocActionAsync('jumpDefinition')

  autocmd FileType sh,rust,go,zsh,vim,scala,python,java,lua nmap <buffer> <silent> gd <Plug>(coc-definition)
  autocmd FileType sh,rust,go,zsh,vim,scala,python,java,lua nmap <buffer> <silent> gy <Plug>(coc-type-definition)
  autocmd FileType sh,rust,go,zsh,vim,scala,python,java,lua nmap <buffer> <silent> gi <Plug>(coc-implementation)
  autocmd FileType sh,rust,go,zsh,vim,scala,python,java,lua nmap <buffer> <silent> gr <Plug>(coc-references)

  " Go to the Type of a variable
  " autocmd FileType c,cpp map <silent> <F4> <Plug>(coc-type-definition)
  "
  " autocmd FileType c,cpp map <silent> <F4> <Plug>(coc-implementation)
  " Find all references for type under cursor
  " autocmd FileType c,cpp map <silent> <F4> <Plug>(coc-references)
  " 
  " autocmd FileType python map <silent> <F4> <Plug>(coc-rename)

  autocmd FileType python map <buffer> <silent> <F3> <Plug>(coc-definition)

  autocmd FileType java map <buffer> <silent> <F3> <Plug>(coc-definition)

  autocmd FileType scala map <buffer> <silent> <F3> <Plug>(coc-definition)
" nmap <silent> [c <Plug>(coc-diagnostic-prev)
" nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Add missing imports on save
  autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

  autocmd FileType rust map <buffer> <leader>a <Plug>(coc-codeaction)

" rust https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.vim
augroup END

endif
" }}}

" ALE {{{
" framework for displaying warnings & errors in source code
if !has('win32unix') && !has('win64unix')
  Plug 'w0rp/ale',programming
  " Plug 'w0rp/ale',{'for':['bash','sh','tex','markdown']}
  " # Prose
  " - https://github.com/amperser/proselint/
  " - https://github.com/redpen-cc/redpen
  " - https://github.com/btford/write-good
  "
  " standalone: https://github.com/languagetool-org/languagetool

  " let g:ale_sign_column_always = 1
  let g:ale_lint_on_enter = 0
  let b:ale_warn_about_trailing_whitespace = 0

  " let g:ale_sign_error = '>>'
  let g:ale_sign_error = '⤫'
  let g:ale_sign_warning = '⚠'

  " :ALEInfo - current settings
  " DEBUG not working by ":ALEInfoToClipboard" and looking at the end for (executable check - failure)

  " cppcheck is very cpu intensive
  "'clang', 'clangcheck', 'cpplint','cppcheck', 'clangtidy'

  " apt-get install clang-tidy shellcheck
  " snap install ruff
  let g:ale_linters = {
        \   'cpp':    ['g++', 'clangtidy'],
        \   'c':      ['clangtidy','gcc'],
        \   'sh':     ['shellcheck'],
        \   'markdown': ['languagetool'],
        \   'text': ['languagetool'],
        \   'mail': ['languagetool'],
        \   'python': ['ruff']
        \}
  let g:ale_languagetool_executable = $HOME."/bin/sp_language_tool_commandline.sh"
  let g:ale_languagetool_options = "--autoDetect"

  " let g:ale_echo_msg_format = '[%linter%] %s'

  " NOTE: ccls is heavy when i open linux (c)
  " coc does this instead: 'rust':   ['rls', 'analyzer'],
  " TODO  'redpen', 'writegood'
  " - redpen config (there is no way of in ALE to configure) http://redpen.herokuapp.com/
" !! :lopen to get a list of more wanring
" 'gcc','cppcheck', 'ccls',

" let g:ale_c_clangtidy_checks = ['-*', 'cppcoreguidelines-*']

" '-*' disable all
" '-XX' disable 'XX'
let g:ale_c_clangtidy_checks = ['-clang-diagnostic-language-extension-token', '-clang-diagnostic-implicit-function-declaration', '-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling', '-clang-analyzer-osx', '-clang-analyzer-optin.osx', '-clang-diagnostic-error']

  " :ALEFix
  " let g:ale_fixers = {
  "       \ 'cpp': ['trim_whitespace']
  "       \ 'c':   ['trim_whitespace']
  "       \}

  let g:ale_cpp_gcc_options="-std=c++17 -Wall -Wextra -I. -Iexternal -I../external -I../external/googletest/googletest -Iexternal/googletest/googletest -Werror-pointer-arith"
  let g:ale_c_gcc_options="-std=gnu11 -Wall -Wextra -I. -Iexternal -I../external -Iinclude -I../include -Wformat"
endif
" }}}

" vim-operator-flashy {{{
" indicate what region of text has been copied by emmiting a brief flash
Plug 'kana/vim-operator-user'
Plug 'haya14busa/vim-operator-flashy'
" TODO change highlight colour
" :h operator-flashy-variables

map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$
" }}}

" DelimitMate {{{
" TODO try https://github.com/jiangmiao/auto-pairs
" Exapnds () {} "" '' []
Plug 'Raimondi/delimitMate',programming_nhaskell

let delimitMate_expand_cr = 1
let delimitMate_smart_matchpairs = 1
let delimitMate_balance_matchpairs = 1
let delimitMate_matchpairs = "(:),[:],{:}"
" ```':'```
" /*:*/
" }}}

" Tagbar {{{
" pane displaying tag information present in current file
Plug 'preservim/tagbar',programming_nhaskell

let g:tagbar_show_linenumbers = -1 " display line number in the tagbar pane
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1        " focus on open
let g:tagbar_indent = 1
let g:tagbar_sort = 0
let g:tagbar_autoclose = 0
let g:tagbar_map_help = ""
nmap <F12> <esc>:TagbarToggle<CR>

let g:tagbar_type_c = {
    \ 'ctagstype' : 'c',
    \ 'kinds'     : [
        \ 'f:functions',
        \ 'v:variables:0:0',
    \ ],
\ }

let g:tagbar_type_cpp = {
    \ 'ctagstype' : 'cpp',
    \ 'kinds'     : [
        \ 'f:functions',
        \ 'v:variables:0:0',
    \ ],
\ }

" \ 'p:prototypes:1:0',
" \ 'c:classes',
" \ 'd:macros:1:0',
" \ 'g:enums',
" \ 'e:enumerators:0:0',
" \ 't:typedefs:0:0',
" \ 'n:namespaces',
" \ 's:structs',
" \ 'u:unions',
" \ 'm:members:0:0',

" }}}

" TComment {{{
" Toggle comments
" gc         | visual select what to comment
" <leader>+c | // comment
" <leader>+= | /* multiline
" TODO make <leader>+c behave as gc in visual mode
" let g:tcomment#filetype#syntax_map = {...}
let g:tcomment_types = {
      \'codipython'            : "# %s"
      \ }

Plug 'tomtom/tcomment_vim'
nmap <leader>c <esc>:TComment<CR>
nmap <leader>= <esc>:TCommentBlock<CR>

" disable all default mappings
" let g:tcommentMaps = 0
let g:tcomment_mapleader_uncomment_anyway = ''
let g:tcomment_mapleader_comment_anyway= ''
let g:tcomment_opleader1 = 'gc'

" Tcomment visual
vmap <leader>c :TComment<CR>
vmap <leader>= :TCommentBlock<CR>
"
" TODO this does not work when selecting multiple commented-out lines and trying to uncomment them
" augroup AugroupTComment
"   autocmd!
"   autocmd FileType c,cpp,objc xnoremap <leader>c :TCommentInline<CR>
" augroup END
" }}}

" {{{
if !has('win32unix') && !has('win64unix')
  " gutentags {{{
  " ctags, cscope & global generation
  Plug 'zpooky/vim-gutentags' ",programming_nhaskell = lazy load does not work correctly
  function! s:SetupGutentag()
    let l:tags = $HOME."/.cache/tags"
    if !isdirectory(l:tags)
      call mkdir(l:tags, "p", 0700)
    endif
    return l:tags
  endfunction

  let g:gutentags_cache_dir = s:SetupGutentag()


  " let g:gutentags_ctags_exclude =[]
  " let g:gutentags_ctags_exclude_wildignore=1
  " let g:gutentags_file_list_command = "find . oe-workdir/recipe-sysroot/usr/include/glib-2.0 oe-workdir/recipe-sysroot/usr/include/alsa oe-workdir/recipe-sysroot/usr/include/glib-utils oe-workdir/recipe-sysroot/usr/include/systemd -type f -not -path '*/.git/*' -not -path '*/unix/*' -not -path '*/checktest/*' -not -path '*/checktests/*' -not -path '*/unittest/*' -not -path '*/tests/*' -not -path '*/stub/*' -not -path '*/stubs/*' -not -path '*/testdir/*'"

  " with custom patch {
  let g:gutentags_file_list_command = "find . -type f -not -path '*/.git/*' -not -path '*/unix/*' -not -path '*/checktest/*' -not -path '*/checktests/*' -not -path '*/checktest_commandsource/*' -not -path '*/unittest/*' -not -path '*/tests/*' -not -path '*/stub/*' -not -path '*/stubs/*' -not -path '*/.ccls-cache/*' -not -path '*/testdir/*' -not -path '*/dummy/*' -not -path '*/host-dummy/*'"
  let g:gutentags_file_list_command_secondary = "find ".'$(test -e '.$HOME.'/dotfiles/lib/git_root.sh && '.$HOME.'/dotfiles/lib/git_root.sh || echo "'.$PWD.'")'."/oe-workdir/recipe-sysroot/usr/include -type f -not -path '*/c++/*'"
  " let g:gutentags_file_list_command_secondary = 'cd $(test -e '.$HOME.'/dotfiles/lib/git_root.sh && '.$HOME."/dotfiles/lib/git_root.sh || echo "."); find oe-workdir/recipe-sysroot/usr/include -type f"
  " echomsg 'cd $(test -e '.$HOME.'/dotfiles/lib/git_root.sh && '.$HOME."/dotfiles/lib/git_root.sh || echo "."); find oe-workdir/recipe-sysroot/usr/include -type f"
  " index function prototypes (useful when we only have to header files)
  let g:gutentags_ctags_extra_args_secondary = ['--c-kinds=+p']  " tags=primary.ctag, header_only.ctag
  " } else {
  " let g:gutentags_file_list_command = "find . oe-workdir/recipe-sysroot/usr/include -type f -not -path '*/.git/*' -not -path '*/unix/*' -not -path '*/checktest/*' -not -path '*/checktests/*' -not -path '*/unittest/*' -not -path '*/tests/*' -not -path '*/stub/*' -not -path '*/stubs/*'"
  " }

  let g:gutentags_modules=['ctags', 'ctags_secondary'] ", 'gtags_cscope'
  let g:gutentags_ctags_executable="ctags"
  let g:gutentags_ctags_tagfile=".tags"
  let g:gutentags_generate_on_missing=1
  let g:gutentags_background_update=1


  let g:gutentags_generate_on_write=1
  let g:gutentags_generate_on_new=1

  " let g:gutentags_trace=1
  " let g:gutentags_define_advanced_commands=1

  let g:gutentags_ctags_exclude=['autoconf','*.md','configure', 'Makefile','CMakeLists.txt','*.cmake','*.mak', '*.am','*.in','*.m4','*.html','*.php','*.py','*.service', '*.mount','*.target','*.css','*.rst', '*.json', 'Session.vim', '*.dtd', '*.patch','*.ac','*.pm','.ccls-cache', 'svg','checktest','*.conf', '*.rs', '*.rb']

  " let g:gutentags_file_list_command = 'ack -f --nohtml --nojson --nomd '
  " let g:gutentags_file_list_command = {
  "       \ 'markers':
  "       \ {'.git': 'ack -f --nohtml --nojson --nomd '}
  "       \ }

        " \ {'.git': 'ack -f --nohtml --nojson --nomd '}
  " let g:gutentags_ctags_executable_cpp="ctag"

  let g:gutentags_project_info=[]
  call add(g:gutentags_project_info, {'type': 'python', 'file': 'setup.py'})
  call add(g:gutentags_project_info, {'type': 'python', 'file': 'requirements.txt'})
  call add(g:gutentags_project_info, {'type': 'python', 'file': 'pyproject.toml'})
  call add(g:gutentags_project_info, {'type': 'ruby', 'file': 'Gemfile'})
  call add(g:gutentags_project_info, {'type': 'haskell', 'glob': '*.cabal'})
  call add(g:gutentags_project_info, {'type': 'haskell', 'file': 'stack.yaml'})
  call add(g:gutentags_project_info, {'type': 'rust', 'file': 'Cargo.toml'})
  call add(g:gutentags_project_info, {'type': 'javascript', 'file': 'package.json'})
  call add(g:gutentags_project_info, {'type': 'c', 'file': 'meson.build'})
  call add(g:gutentags_project_info, {'type': 'c', 'file': 'Makefile'})

  " gtags
  " let g:gutentags_gtags_executable="gtags"
  " let g:gutentags_gtags_cscope_executable = 'gtags-cscope'
  " let g:gutentags_auto_add_gtags_cscope = 1

  " }}}
endif
" }}}

" neoformat {{{
" support for different code formatters
Plug 'sbdchd/neoformat'

let g:neoformat_enabled_cpp = ['clangformat']
let g:neoformat_enabled_c = ['clangformat']

" pip3 install --user yapf --upgrade
" apt-get install yapf3 isort
let g:neoformat_python_spyapf = {
      \ 'args': ['--style="$HOME/style.py"'],
      \ 'exe': 'yapf3',
      \ 'stdin': 1,
      \ }
let g:neoformat_enabled_python = ['isort', 'spyapf']

" - yay -S shfmt
" - manualy install from https://github.com/mvdan/sh/releases (which is a static linked binary)
let g:neoformat_enabled_sh = ['shfmt']

" npm install --global prettier --upgrade
let g:neoformat_enabled_javascript = ['prettier']

" cargo install rustfmt
let g:neoformat_enabled_rust = ['rustfmt']
" yay -S jq
let g:neoformat_enabled_json = ['jq']
" npm install -g prettier
let g:neoformat_enabled_java = ['prettier']

let g:neoformat_only_msg_on_error = 1

" TODO scala,java

augroup AugroupNeoformat
  autocmd!
  autocmd FileType c,cpp,python,sh,bash,zsh,javascript,rust,json,scala,java,lua,html,glsl nnoremap <buffer><leader>f <esc>:Neoformat<CR>
  autocmd FileType c,cpp,python,sh,bash,zsh,javascript,rust,json,scala,java,lua,html,glsl vnoremap <buffer><leader>f <esc>:Neoformat<CR>
augroup END

" debug:
" let g:neoformat_verbose = 1
" }}}

" Codi {{{
" repl based on content from current file
Plug 'zpooky/codi.vim', { 'on': 'Codi' }

" if executable('python')
" elseif executable('python3')
let g:codi#interpreters = {
   \ 'python': {
       \ 'bin': 'python3',
       \ 'prompt': '^\(>>>\|\.\.\.\) ',
       \ },
   \ }
" else
"   echomsg "missing python"
" endif

" " delay refresh
" let g:codi#autocmd = 'InsertLeave'
"
" let g:codi#width = 120
let g:codi#rightalign = 0
" let g:codi#raw = 1

" # vim             command
" Codi [filetype] - activates Codi
" Codi!           - deactivates Codi
" }}}

" vimux {{{
Plug 'benmills/vimux'
let g:VimuxOrientation = "h"
let g:VimuxHeight = "26"

function! VimuxSpTest()
  call VimuxSendKeys("C-c")       " abort already running test
  call VimuxRunCommand("$HOME/dotfiles/lib/vim_smart_test.sh \"" . expand("%:p") . "\" " . line("."))
endfunction

function! VimuxSpPerf()
  call VimuxSendKeys("C-c")
  call VimuxRunCommand("$HOME/dotfiles/lib/vim_perf.sh \"" . expand("%:p") . "\" " . line("."))
endfunction

function! VimuxSpMan()
  call VimuxSendKeys("C-c")
  let wordUnderCursor = expand("<cword>")
  call VimuxRunCommand("man ". wordUnderCursor)
endfunction

function! VimuxSpTranslate()
  call VimuxSendKeys("q")
  let wordUnderCursor = expand("<cword>")
  " https://github.com/soimort/translate-shell
  call VimuxRunCommand("trans -d :en -v -- \"" . wordUnderCursor . "\"")
endfunction

augroup AugroupVimux
  autocmd!

  " <leader+t> run gtest test based on the cursor position in a test file
  autocmd FileType c,cpp,objc noremap <buffer> <silent> <leader>t <esc>:call VimuxSpTest()<CR>
  " <leader+t> run a translate program for the word under the cursor
  autocmd FileType md,markdown,text noremap <buffer> <silent> <leader>t <esc>:call VimuxSpTranslate()<CR>

  " <leader+p> run gtest test under perf based on the cursor position in a test file
  autocmd FileType c,cpp,objc noremap <buffer> <silent> <leader>p <esc>:call VimuxSpPerf()<CR>

  " <leader+l> run man for current word under the cursor
  " autocmd FileType c,cpp noremap <silent> <leader>l <esc>:call VimuxSpMan()<CR>
augroup END
" }}}
"
" cpp {{{
" if has('win32unix') || has('win64unix') || has('win32') || has('win64') || !has('nvim')
  " vim-cpp-enhanced-highlight {{{
  " better c++ syntax
  Plug 'octol/vim-cpp-enhanced-highlight',programming_cpp
  " Plug 'abudden/taghighlight-automirror'
  " syntax keyword cppSTLnamespace debug
  " syntax keyword cppSTLnamespace local
  " syntax keyword cppSTLnamespace header
  " syntax keyword cppSTLnamespace sp
  " syntax keyword cppSTLnamespace util
  let g:cpp_class_scope_highlight = 0           " Highlighting of class scope
  let g:cpp_experimental_template_highlight = 0 " Highlighting of template functions
  let g:cpp_posix_standard = 1
  " let g:cpp_member_variable_highlight = 1
  " }}}

" else
"   " Chromatica {{{
"   Plug 'arakashic/chromatica.nvim'  ",{'for':['c','cpp'], 'do': ':UpdateRemotePlugins' }
"   let g:chromatica#enable_at_startup=1
"   let g:chromatica#responsive_mode = 1
"
"   " let g:chromatica#debug_log = 1
"   " let g:chromatica#debug_profiling = 1
"
"   if has('win32') || has('win64')
"     let g:chromatica#libclang_path="D:\\Program Files\\LLVM\\lib\\libclang.lib"
"   else
"     let g:chromatica#libclang_path=spooky_libclang
"   endif
"   " }}}
" endif
" }}}

" {{{
" vim-scala {{{
" scala support
" Plug 'derekwyatt/vim-scala',programming_scala
" https://scalameta.org/metals/docs/editors/vim.html
"  https://github.com/scalameta/nvim-metals

augroup AugroupScala
  au BufRead,BufNewFile *.sbt set filetype=scala
augroup END

"TODO format-> :SortScalaImports

let g:scala_use_default_keymappings = 0
" }}}
" }}}

" syntax {{{
" rfc syntax
Plug 'vim-scripts/rfc-syntax', { 'for': 'rfc' }
" glsl
Plug 'tikhomirov/vim-glsl'
" }}}

" markdown {{{
Plug 'tpope/vim-markdown'
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'c', 'dts', 'xml', 'strace', 'zsh=sh', 'cpp', 'vim', 'lua', 'make', 'ld', 'asm', 'json', 'diff', 'java', 'scala', 'haskell', 'sql']
let g:markdown_syntax_conceal = 0
let g:markdown_minlines = 9000
let g:markdown_recommended_style=0
" }}}

" {{{
" Integrate split navigation with tmux
Plug 'christoomey/vim-tmux-navigator'
" }}}

" git {{{
" better git commmit interface
Plug 'rhysd/committia.vim'
Plug 'tpope/vim-fugitive'
" }}}

" {{{
" # vim-surround
" adds commands to surround: _word_

" ds(   - delete surrounding '()'
" cs([  - change surrounding '()' to '[]'
" ysiw] - surround 'iw' with '[]'
" S)    - in Visual mode insert selected with '()'
Plug 'tpope/vim-surround'

" to make repeat(.) work with vim-surround
" Plug 'tpope/vim-repeat'
" }}}

" {{{
" gl    | shift argument right
" gh    | shift argument left
Plug 'AndrewRadev/sideways.vim',{'branch': 'main'}
" let dict = Hash<String, Vec<String>>::new();
" []string{"One", "Two", "Three"}
" dict = {one: 1, two: 2, three: 3}
" std::unordered_map<k, v>()
" let xs = [1;2;3]
" <input name="one" id="two" class="three" />
" a { color: #fff; background: blue; text-decoration: underline; }

" classhes with vim-lion
" nnoremap gl :SidewaysRight<CR>
"
nnoremap gh :SidewaysLeft<CR>
" }}}

" CommandT {{{
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" listing files
" https://github.com/junegunn/fzf/issues/2687#issuecomment-1174569613
function! GitFZF()
  let l:path = expand('%:p:h')
  if executable('git')
    let l:tmp_path = trim(system('cd '.shellescape(expand('%:p:h')).' && git rev-parse --show-toplevel'))
    if isdirectory(l:tmp_path)
      let l:path = l:tmp_path
    endif
  endif
  exe 'FZF ' . l:path
endfunction
command! GitFZF call GitFZF()
nnoremap <silent> <leader>r <Esc>:GitFZF<CR>
" noremap <silent> <leader>r <Esc>:Files<CR>
nnoremap <silent> <leader>. <Esc>:Tags<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" interactive grep
noremap <silent> <leader>g <Esc>:RG<CR>
" }}}

" {{{
" additional *in* support like ci, to change between two ,
Plug 'wellle/targets.vim'
" }}}

" {{{
" hint what char should used with f
" Plug 'unblevable/quick-scope'
Plug 'unblevable/quick-scope'

" display only when these keys has been presed
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" }}}


" {{{
" Visual select + * will search the selected
Plug 'bronson/vim-visual-star-search'
" }}}

" Statusline {{{
" if has('win32unix') || has('win64unix') || $TERM == "linux" || has('nvim') || has('win32') || has('win64')
"   Plug 'vim-airline/vim-airline'
"
"   if has('win32unix') || has('win64unix') || has('win32') || has('win64')
"     " augroup AutogroupCygwinCppVisual
"     "   autocmd!
"     " autocmd FileType cpp map <silent> <F11> <Esc> :set laststatus=0 <Bar> :AirlineToggle<CR>
"     " augroup END
"     map <silent> <F11> <Esc> :set laststatus=0 <Bar> :AirlineToggle<CR>
"   endif
" else
"   python3 from powerline.vim import setup as powerline_setup
"   python3 powerline_setup()
"   python3 del powerline_setup
" endif
" 0: never
" 1: only if there are at least two windows
" 2: always
set laststatus=0
" }}}


" custom tab bar {{{
Plug 'zpooky/tabline.vim'
" }}}

" {{{
" To support % between \begin{} and \end{} in LaTeX
" Plug 'adelarsq/vim-matchit', { 'for':['tex','html'] }
" }}}

" {{{
Plug 'xuhdev/vim-latex-live-preview',{'for':['tex','plaintex']}
" https://wiki.gnome.org/Apps/Evince
" https://okular.kde.org/

" :LLPStartPreview
" }}}

" bitbake syntax {{{
" Plug 'kergoth/vim-bitbake'
" }}}

" align text around character {{{
" markdown table align format
let g:lion_squeeze_spaces = 1
"
" visual mode: 'gl|': align in paragraph around =
"
Plug 'tommcdo/vim-lion'
" }}}

" {{{
" standout
if has('nvim')
Plug 'zpooky/vim-illuminate', {'for':['c','cpp','vim','shell','make','go', 'lua']}
else
Plug 'zpooky/vim-illuminate', {'for':['c','cpp','vim','shell','make','python','go', 'java', 'scala', 'lua']}
endif

" hi link illuminatedWord MatchParen
" hi illuminatedWord cterm=underline gui=underline
" hi link illuminatedWord CursorLine
" hi link illuminatedWord Pmenu
hi link illuminatedWord SpIlluminated
"
let g:sh_no_error = 1
let g:Illuminate_delay = 100
let g:Illuminate_ftblacklist = ['vim-plug', '', 'gitcommit', 'tagbar']
" by default most things are highlighted, this overrides that:
let g:Illuminate_ftHighlightGroups = {
      \ 'vim': ['vimVar', 'vimString', 'vimFuncName', 'vimFunction', 'vimUserFunc', 'vimFunc','vimOption'],
      \ 'shell': ['shDerefSimple', 'shDeref', 'shVariable'],
      \ 'sh': ['shDerefSimple', 'shDeref', 'shVariable'],
      \ 'make': ['makeIdent', 'makeTarget'],
      \ 'java': ['javaFunction', 'javaIdentifier', 'javaConstant'],
      \ }

let g:Illuminate_ftHighlightGroupsBlacklist = {
      \ 'vim': ['vimFuncKey'],
      \ 'c': ['cType', 'cConditional','cNumbers', 'cNumber', 'cRepeat', 'cStructure', 'cStorageClass','cBoolean', 'cComment', 'cCommentL','cCppString','cInclude', 'cOperator','cSpecialCharacter','cDefine'],
      \ 'cpp': ['cType','cppType','cppStatement','cOperator','cppSTLtype','cCppString','cppModifier','cppSTLnamespace','cppExceptions','cppSTLconstant','cNumber','cppNumber','cStorageClass','cStructure','cConditional','cppCast','cCppOutWrapper','cComment', 'cCommentL'],
      \ 'python': ['pythonStatement','pythonRepeat','pythonOperator','pythonString','pythonConditional','pythonNumber','pythonComment','pythonInclude'],
      \ 'go': ['goDecimalInt', 'goComment', 'goString'],
      \ 'java': ['javaType'],
      \ }
"  'cStatement',
" }}}

" {{{
if executable('aspell')
  Plug 'Konfekt/vim-DetectSpellLang'
  let g:detectspelllang_langs = {}
  let g:detectspelllang_langs.aspell = [ 'en_GB', 'sv' ]
endif
" }}}

" {{{
" Plug 'ConradIrwin/vim-bracketed-paste'
" }}}

" {{{
Plug 'nathanaelkane/vim-indent-guides', {'for':['python']}
" call s:InitVariable('g:indent_guides_indent_levels', 30)
" call s:InitVariable('g:indent_guides_auto_colors', 1)
" call s:InitVariable('g:indent_guides_color_change_percent', 10) " ie. 10%
" call s:InitVariable('g:indent_guides_guide_size', 0)
" call s:InitVariable('g:indent_guides_start_level', 1)
" call s:InitVariable('g:indent_guides_enable_on_vim_startup', 0)
" call s:InitVariable('g:indent_guides_debug', 0)
" call s:InitVariable('g:indent_guides_space_guides', 1)
" call s:InitVariable('g:indent_guides_tab_guides', 1)
" call s:InitVariable('g:indent_guides_soft_pattern', '\s')
" call s:InitVariable('g:indent_guides_default_mapping', 1)
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

let g:indent_guides_auto_colors = 0
augroup AugroupVimIndentGuides
  autocmd!
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#262626 ctermbg=3
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#262626 ctermbg=4
augroup END

" }}}

