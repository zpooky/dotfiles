"     k
" h     l
"   j

if has('win32') || has('win64')
  source D:\cygwin64\home\fredrik\.standardvimrc

  let g:python_host_prog = "C:\\Python27\\python.exe"
  let g:python3_host_prog = "C:\\Python36\\python.exe"
else
  source $HOME/.standardvimrc
endif

if has('nvim')
  " - sh
  "   - npm install bash-language-server
  "   - yay -S bash-language-server shfmt
  " - js
  "   - npm install -g neovim
  "   - yay -S nodejs-neovim
  " - python2
  "   - pip2 install --user --upgrade jedi
  "   - yay -S python2-neovim python2-jedi
  " - python3
  "   - pip3 install --user --upgrade jedi
  "   - yay -S python-neovim python-jedi
  "   - pip3 install pynvim --upgrade
  " - ruby
  "   - yay -S ruby-neovim
  "   - gem install neovim
  " - docker
  "   - npm install -g dockerfile-language-server-nodejs
  " - rust
  "   - rustup component add rustfmt
  " - json
  "   - yay -S jq
  " - scala
  "   - yay -S metals
  " - markdown
  "   - yay -S redpen languagetool
  "
  " npm install --global prettier --upgrade
  " pip3 install --user yapf --upgrade
  " pip3 install --upgrade neovim
  "
  " :checkhealth
endif

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
if has('nvim')
  call plug#begin('~/.config/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif

let programming_ncpp=         {'for':[          'haskell','scala','java','python','vim','bash','sh','xml','markdown','conf','text','zsh','gdb','asm','nasm','make','m4','json','rust','ruby','yaml','sql','go','awk','html','cmake','javascript','ocaml']}
let programming_ncpp_nhaskell={'for':[                    'scala','java','python','vim','bash','sh','xml','markdown','conf','text','zsh','gdb','asm','nasm','make','m4','json','rust','ruby','yaml','sql','go','awk','html','cmake','javascript','ocaml']}
let programming=              {'for':['c','cpp','haskell','scala','java','python','vim','bash','sh','xml','markdown','conf','text','zsh','gdb','asm','nasm','make','m4','json','rust','ruby','yaml','sql','go','awk','html','cmake','javascript','ocaml']}
let programming_nhaskell=     {'for':['c','cpp',          'scala','java','python','vim','bash','sh','xml','markdown','conf','text','zsh','gdb','asm','nasm','make','m4','json','rust','ruby','yaml','sql','go','awk','html','cmake','javascript','ocaml']}
let programming_cpp=          {'for':['c','cpp']}
let programming_haskell=      {'for':'haskell'}
let programming_scala=        {'for':'scala'}

" {{{
Plug 'tbastos/vim-lua'
let g:lua_syntax_nofold = 1
let g:lua_syntax_nosymboloperator = 1
" }}}

" nvim tree-sitter {{{
if has('nvim') && has('nvim-0.5.0')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'zpooky/cglobal'
" NOTE: while hang if we insert allot of [[[[...]]]]
" Plug 'p00f/nvim-ts-rainbow'
endif

if 1
" rainbow scope {{{
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

      " \   'c': {
      " \     'parentheses':[['\(\#ifdef\|\#ifndef\|\#if\)','\(\#elif\|\#else\)','\#endif'], 'start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
      " \   },

      " has no effect
      " \   'sh': {
      " \     'parentheses': [['\(^\|\s\)\S*()\s*{\?\($\|\s\)','_^{_','}'], ['\(^\|\s\)if\($\|\s\)','_\(^\|\s\)\(then\|else\|elif\)\($\|\s\)_','\(^\|\s\)fi\($\|\s\)'], ['\(^\|\s\)for\($\|\s\)','_\(^\|\s\)\(do\|in\)\($\|\s\)_','\(^\|\s\)done\($\|\s\)'], ['\(^\|\s\)while\($\|\s\)','_\(^\|\s\)\(do\)\($\|\s\)_','\(^\|\s\)done\($\|\s\)'], ['\(^\|\s\)case\($\|\s\)','_\(^\|\s\)\(\S*)\|in\|;;\)\($\|\s\)_','\(^\|\s\)esac\($\|\s\)']],
      " \   },

" vim:
" \           'parentheses': [['fu\w* \s*.*)','endfu\w*'], ['for','endfor'], ['while', 'endwhile'], ['if','_elseif\|else_','endif'], ['(',')'], ['\[','\]'], ['{','}']],

" NOTE: fortran is dummy used for *.fpp files

" }}}
endif
" }}}

" coc.vim {{{
if executable('ccls')
  Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}, 'branch': 'release', 'for': ['cpp','sh','rust','go','zsh','vim','scala','python','java','lua','c']}
  augroup AugroupCocCPP
    autocmd!
    autocmd FileType c,cpp unmap <f3>
    autocmd FileType c,cpp map <silent> <F3> <Plug>(coc-definition)

    autocmd FileType c,cpp nmap <silent> gd <Plug>(coc-definition)
    autocmd FileType c,cpp nmap <silent> gy <Plug>(coc-type-definition)
    autocmd FileType c,cpp nmap <silent> gi <Plug>(coc-implementation)
    autocmd FileType c,cpp nmap <silent> gr <Plug>(coc-references)
    autocmd FileType c,cpp map <silent> <F4> <Plug>(coc-rename)
  augroup END
else
  Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}, 'branch': 'release', 'for': ['sh','rust','go','zsh','vim','scala','python','java','lua']}
endif
let g:coc_global_extensions = [ 'coc-css', 'coc-json', 'coc-yaml', 'coc-xml', 'coc-java', 'coc-rls', 'coc-rust-analyzer', 'coc-go', 'coc-metals', 'coc-sql', 'coc-vimlsp', 'coc-jedi', 'coc-lua']
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

" c++ {
" set updatetime=300
" au CursorHold * sil call CocActionAsync('highlight')
" au CursorHoldI * sil call CocActionAsync('showSignatureHelp')

augroup AugroupCoc
  autocmd!
  autocmd FileType sh,rust,go,zsh,vim,scala,python,java,lua unmap <f3>
  " autocmd FileType cpp,sh,c,rust,go,zsh,vim,scala,python,java unmap gd
  autocmd FileType sh,rust,go,zsh,vim,scala,python,java,lua map <silent> <F3> <Plug>(coc-definition)
  " autocmd FileType cpp,sh,c,rust,go,zsh map <silent> <leader><F3> :tabedit % | call CocActionAsync('jumpDefinition')

  autocmd FileType sh,rust,go,zsh,vim,scala,python,java,lua nmap <silent> gd <Plug>(coc-definition)
  autocmd FileType sh,rust,go,zsh,vim,scala,python,java,lua nmap <silent> gy <Plug>(coc-type-definition)
  autocmd FileType sh,rust,go,zsh,vim,scala,python,java,lua nmap <silent> gi <Plug>(coc-implementation)
  autocmd FileType sh,rust,go,zsh,vim,scala,python,java,lua nmap <silent> gr <Plug>(coc-references)

  " Go to the Type of a variable
  " autocmd FileType c,cpp map <silent> <F4> <Plug>(coc-type-definition)
  "
  " autocmd FileType c,cpp map <silent> <F4> <Plug>(coc-implementation)
  " Find all references for type under cursor
  " autocmd FileType c,cpp map <silent> <F4> <Plug>(coc-references)
  " 
  autocmd FileType python map <silent> <F4> <Plug>(coc-rename)


  autocmd FileType python map <silent> <F3> <Plug>(coc-definition)

  autocmd FileType java map <silent> <F3> <Plug>(coc-definition)

  autocmd FileType scala map <silent> <F3> <Plug>(coc-definition)
" nmap <silent> [c <Plug>(coc-diagnostic-prev)
" nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Add missing imports on save
  autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

  autocmd FileType rust map <leader>a <Plug>(coc-codeaction)

" rust https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.vim
augroup END

" }}}

" {{{
" Create split focusing only on the selected
" :NR
" Plug 'chrisbra/NrrwRgn',programming
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
  let g:ale_linters = {
        \   'cpp':    ['g++', 'ccls'],
        \   'c':      ['clangtidy','gcc'],
        \   'sh':     ['shellcheck'],
        \   'markdown': ['languagetool'],
        \   'text': ['languagetool'],
        \   'mail': ['languagetool'],
        \   'python': []
        \}
  let g:ale_languagetool_executable = $HOME."/bin/sp_language_tool_commandline.sh"
  let g:ale_languagetool_options = "--autoDetect"

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
Plug 'majutsushi/tagbar',programming_nhaskell

let g:tagbar_show_linenumbers = -1 " display line number in the tagbar pane
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1        " focus on open
let g:tagbar_indent = 0
nmap <F12> <esc>:TagbarToggle<CR>

let g:tagbar_type_c = {
    \ 'ctagstype' : 'c',
    \ 'kinds'     : [
        \ 'f:functions',
        \ 'v:variables:0:0',
    \ ],
\ }

let g:tagbar_type_cpp = {
    \ 'ctagstype' : 'c',
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
  let g:gutentags_gtags_executable="gtags"
  let g:gutentags_gtags_cscope_executable = 'gtags-cscope'
  let g:gutentags_auto_add_gtags_cscope = 1

  " }}}
endif
" }}}

" neoformat {{{
" support for different code formatters
Plug 'sbdchd/neoformat'

let g:neoformat_enabled_cpp = ['clangformat']
let g:neoformat_enabled_c = ['clangformat']

let g:neoformat_python_spyapf = {
      \ 'args': ['--style="$HOME/style.py"'],
      \ 'exe': 'yapf',
      \ 'stdin': 1,
      \ }
let g:neoformat_enabled_python = ['spyapf']
let g:neoformat_enabled_sh = ['shfmt']
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_rust = ['rustfmt']
let g:neoformat_enabled_json = ['jq']

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
Plug 'metakirby5/codi.vim', { 'on': 'Codi' }

" let g:codi#interpreters = {
"       \ 'python': {
"       \ 'bin': 'python3',
"       \ },
"       \ }

" " delay refresh
" let g:codi#autocmd = 'InsertLeave'
"
" let g:codi#width = 120
let g:codi#rightalign = 0

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
  autocmd FileType c,cpp,objc noremap <silent> <leader>t <esc>:call VimuxSpTest()<CR>
  " <leader+t> run a translate program for the word under the cursor
  autocmd FileType md,markdown,text noremap <silent> <leader>t <esc>:call VimuxSpTranslate()<CR>

  " <leader+p> run gtest test under perf based on the cursor position in a test file
  autocmd FileType c,cpp,objc noremap <silent> <leader>p <esc>:call VimuxSpPerf()<CR>

  " <leader+l> run man for current word under the cursor
  " autocmd FileType c,cpp noremap <silent> <leader>l <esc>:call VimuxSpMan()<CR>
augroup END
" }}}
"
" {{{
" Run script in background
Plug 'joonty/vim-do'

function! VimDoSpScript(script)
  call do#Execute(a:script . " \"" . expand("%:p") . "\" " . line("."),1)
endfunction

augroup AugroupVimDo
  autocmd!
  " command! -nargs=* Do call do#Execute(<q-args>)
  " command! -nargs=* DoQuietly call do#Execute(<q-args>, 1)
  " command! -range DoThis call do#ExecuteSelection()
  "
  " ~/dotfiles/lib/tmuxgdb/teamcoil_gen.sh ./test/thetest.exe '--gtest_filter="*btree*"'

  "
  autocmd FileType c,cpp,objc noremap <silent> <leader>g <esc>:call VimDoSpScript("$HOME/dotfiles/lib/vim_gdb.sh")<CR>
  "
  autocmd FileType c,cpp,objc noremap <silent> <leader>u <esc>:call VimDoSpScript("$HOME/dotfiles/lib/vim_gdb_until.sh")<CR>

augroup END
" }}}

" {{{
" #######
" # cpp #
" #######
" vim-projectionist {{{
" Plug 'tpope/vim-projectionist',programming_cpp
"
" augroup AugroupAVIM
"   autocmd!
"   " toggle between header and source
"   autocmd FileType c,cpp,objc map <silent> <F2> :A<CR>
"   " open source or header in vertical split
"   autocmd FileType c,cpp,objc map <silent> <leader><F2> :AV<CR>
"
"   autocmd User ProjectionistDetect
"         \ call projectionist#append(getcwd(),
"         \ {
"         \    '*.c': {
"         \      'alternate': '{}.h'
"         \    },
"         \    '*.cpp': {
"         \      'alternate': ['{}.h', '{}.hpp', '{}.hh']
"         \    },
"         \    '*.h': {
"         \      'alternate': ['{}.cpp', '{}.c']
"         \    },
"         \    '*.hpp': {
"         \      'alternate': ['{}.cpp']
"         \    },
"         \    '*.hh': {
"         \      'alternate': ['{}.cpp']
"         \    },
"         \    'lib/*.c': { 'alternate': 'include/linux/{}.h' },
"         \    'kernel/*.c': { 'alternate': 'include/linux/{}.h' },
"         \    'include/linux/*.h': { 'alternate': [ 'kernel/{}.c', 'lib/{}.c' ] },
"         \ })
"
" augroup END
" }}}

" {{{
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
" ###########
" # Haskell #
" ###########
" Haskell code completion
Plug 'eagletmt/neco-ghc',programming_haskell

" vim2hs {{{
Plug 'dag/vim2hs',programming_haskell

let g:haskell_conceal_wide = 1
" 0 = disable all conceals, including the simple ones like
" lambda and composition
" let g:haskell_conceal              = 1

" 0 = disable concealing of "enumerations": commatized lists like
" deriving clauses and LANGUAGE pragmas,
" otherwise collapsed into a single ellipsis
" let g:haskell_conceal_enumerations = 1

" }}}

" }}}

" {{{
" #########
" # scala #
" #########
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

" {{{
" ##########
" # syntax #
" ##########
" rfc syntax
Plug 'vim-scripts/rfc-syntax', { 'for': 'rfc' }
" systemd syntax
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'nickhutchinson/vim-cmake-syntax'
" }}}

" {{{
" ##########
" # text   #
" ##########

" Pencil {{{
" Plug 'reedes/vim-pencil', { 'for': 'markdown' }

" hardwrap - vim adds newlines character when line is to long
" softwrap - vim presents long lines wrapped over multiple lines

" TODO
" let g:pencil#wrapModeDefault = 'hard'
" augroup AugroupPencil
"   autocmd!
"   autocmd FileType markdown,mkd call pencil#init()
"   autocmd FileType text         call pencil#init({'wrap': 'hard'})
"   autocmd FileType gitcommit         call pencil#init({'wrap': 'hard'})
" augroup END

" affects HardPencil only - blacklist formatting for text with tagged by these syntax
" highlight group
" let g:pencil#autoformat_config = {
"       \   'markdown': {
"       \     'black': [
"       \       'htmlH[0-9]',
"       \       'markdown(Code|H[0-9]|Url|IdDeclaration|Link|Rule|Highlight[A-Za-z0-9]+)',
"       \       'markdown(FencedCodeBlock|InlineCode)',
"       \       'mkd(Code|Rule|Delimiter|Link|ListItem|IndentCode)',
"       \       'mmdTable[A-Za-z0-9]*',
"       \     ],
"       \     'white': [
"       \      'markdown(Code|Link)',
"       \     ],
"       \   },
"       \ }
" }}}

" Goyo {{{
" Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
"
" augroup AugroupGoyo
"   autocmd!
"   autocmd FileType markdown,mail,text,gitcommit map <silent> <F11> <Esc> :Goyo <CR>
" augroup END
" }}}

" markdown syntax {{{
" Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
" let g:vim_markdown_new_list_item_indent = 2
" let g:vim_markdown_auto_insert_bullets = 0
" let g:vim_markdown_folding_style_pythonic = 1

" Plug 'reedes/vim-colors-pencil'   " http://sherifsoliman.com/2016/05/30/favorite-vim-plugins/#vim-colors-pencil
" }}}

" markdown {{{
Plug 'tpope/vim-markdown'
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'c', 'dts', 'xml', 'strace', 'zsh=sh', 'cpp', 'vim', 'lua', 'make', 'ld', 'asm', 'json']
let g:markdown_syntax_conceal = 0
let g:markdown_minlines = 9000
" }}}

" {{{
" ########
" # tmux #
" ########
" Integrate split navigation with tmux
Plug 'christoomey/vim-tmux-navigator'

if !has("patch-8.2.2345") && !has('nvim')
" makes in tmux switching to a vim pane trigger an on-focus event
Plug 'tmux-plugins/vim-tmux-focus-events'
endif
" }}}

" {{{
" ########
" # git  #
" ########
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
Plug 'tpope/vim-repeat'
" }}}

" {{{
" Plug 'machakann/vim-swap'
" omap i, <Plug>(swap-textobject-i)
" xmap i, <Plug>(swap-textobject-i)
" omap a, <Plug>(swap-textobject-a)
" xmap a, <Plug>(swap-textobject-a)

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

nnoremap gl :SidewaysRight<CR>
" TODO not working
nnoremap gh :SidewaysLeft<CR>
" }}}

" CommandT {{{
if !has('win32') && !has('win64') && 0
  " fuzzy search (TODO do step does not work)
  Plug 'wincent/command-t',{'do':'rake make'}

  noremap <silent> <leader>r <Esc>:CommandT<CR>
  " noremap <silent> <leader>O <Esc>:CommandTFlush<CR>
  " noremap <silent> <leader>m <Esc>:CommandTBuffer<CR>
  " noremap <silent> <leader>. <esc>:CommandTTag<cr>
  nmap <silent> <Leader>. <Plug>(CommandTTag)

  " bitbake: oe-logs,oe-workdir
  let g:CommandTWildIgnore=&wildignore . ",*.log,oe-logs,oe-workdir,*.wav"
  let g:CommandTFileScanner="find"

  " let g:CommandTTagIncludeFilenames=1
else
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
endif
" }}}

" " include git:gitignore in vim:wildignore {{{
" TODO Plug 'euclio/gitignore.vim'
" https://www.vim.org/scripts/script.php?script_id=2557 https://github.com/vim-scripts/gitignore
" " }}}

" tagbar {{{
" pane displaying tag information present in current file
" Plug 'majutsushi/tagbar',programming_nhaskell

" nmap <silent> <F10> <esc>:TagbarToggle<CR>
" imap <silent> <F10> <ESC>:TagbarToggle<CR>
" cmap <silent> <F10> <ESC>:TagbarToggle<CR>
" }}}


" {{{
" historic buffer navigation
" TODO
" Plug 'ton/vim-bufsurf'
" }}}
"
" {{{
" additional *in* support like ci, to change between two ,
Plug 'wellle/targets.vim'
" }}}

" Centre search result {{{
" Plug 'wincent/loupe'
noremap n nzz
noremap N Nzz
" }}}

" {{{
" hint what char should used with f
" Plug 'unblevable/quick-scope'
Plug 'bradford-smith94/quick-scope'

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


" {{{
" translate colorc codes inline into colors
Plug 'chrisbra/Colorizer', { 'for': 'vim' }

" let g:colorizer_auto_filetype='vim'
let g:colorizer_colornames_disable = 1
" }}}

" custom tab bar {{{
Plug 'zpooky/tabline.vim'
" }}}

" {{{
" To support % between \begin{} and \end{} in LaTeX
Plug 'adelarsq/vim-matchit', { 'for':['tex','html'] }
" }}}

" {{{
Plug 'xuhdev/vim-latex-live-preview',{'for':['tex','plaintex']}
" https://wiki.gnome.org/Apps/Evince
" https://okular.kde.org/

" :LLPStartPreview
" }}}

" meson syntax {{{
Plug 'matze/vim-meson'
" }}}

" bitbake syntax {{{
Plug 'kergoth/vim-bitbake'
" }}}

" better vim session {{{
Plug 'tpope/vim-obsession'
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
" Plug 'chaoren/vim-wordmotion'
" change definition of what is a word(w) (CamelCase, _ seperated words, ...)
" CamelCaseACRONYMWords_underscore1234
" }}}

" {{{
" Plug 'chriskempson/base16-vim'
" }}}

" {{{
Plug 'tikhomirov/vim-glsl'
" }}}

" {{{
" rust Cargo.toml
Plug 'cespare/vim-toml'
" }}}

" {{{
Plug 'uiiaoo/java-syntax.vim'
highlight link JavaIdentifier NONE
" }}}

" {{{
Plug 'vim-python/python-syntax'
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
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#262626   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#262626 ctermbg=4

" }}}

call plug#end()
" }}}

" {{{

colorscheme codedark

" colorscheme {{{
" if has('win32unix') || has('win64unix')
  " wrk {{{
" augroup AugroupColorscheme
"   autocmd!
"   " autocmd FileType * colorscheme codedark
" augroup END

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
  augroup AugroupCygwin
    autocmd!
    autocmd BufWritePre * if &ff != 'dos' && expand('%:p') =~ "^\/cygdrive\/d\/Worksapce\/" && expand('%:p') !~ "\/Dropbox\/" && input('set ff to dos [y]') == 'y' | setlocal ff=dos | endif
  augroup END
endif


if has('nvim') && has('nvim-0.5.0')
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  cglobal = {
    enable = true
  }
}
EOF
endif

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
  " let l:shell_command = [&shell, &shellcmdflag, l:command1 . "&&" . l:command2]
  let l:shell_command = [&shell, &shellcmdflag, l:command1]
  let j = job_start(l:shell_command) ", {'out_cb': 'JobCallback', 'exit_cb': 'JobCallback'}
endfunction

command! GDBBreak :call GDBBreak()
augroup AugroupGDB
  autocmd!
  autocmd FileType c,cpp,objc nnoremap <leader>j <esc>:GDBBreak<CR>
augroup END
" }}}

" format json {{{
" function! FormatJson()
"   :mark o
"   " format json file using 2 space indentation
"   exec "%!python ~/dotfiles/lib/json_format.py 2"
"   :normal `o
" endfunction!
" command! FormatJson :call FormatJson()
"
" augroup AugroupFormatJson
"   autocmd!
"   autocmd FileType json nnoremap <buffer><leader>f <esc>:FormatJson<CR>
" augroup END
" }}}

" debug syntax {{{
function! s:SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

command! SynStack :call s:SynStack()
map <F7> :SynStack<CR>
" }}}

" vim-markdown {{{
" supress issue where unmatch _ (italic) will cause bright red error
hi link markdownError Normal
augroup AugroupMarkdown
  autocmd!
  " suppress '0:' error
  autocmd FileType markdown hi link pythonNumberError Normal
  " suppress '{' error
  autocmd FileType markdown hi link cErrInParen Normal
augroup END
" }}}
