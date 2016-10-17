" general
" set number
set relativenumber
set ic
set hls
syntax on
" tabbs
set tabstop=2
set shiftwidth=2
set expandtab
" pathogen plugin manager
execute pathogen#infect()
filetype plugin indent on
" vim2hs
let g:haskell_conceal_wide = 1
" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"syntastic c++
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++14 -Wall -Wextra -Wpedantic'

let g:syntastic_cpp_checkers=["clang_check","g++","cpp_check"]

" gf command
let &path.="src/include,/usr/include/AL,src/headers,headers,../headers"

" you complete me
" disable confirm
let g:ycm_confirm_extra_conf = 0

hi clear SpellBad
hi SpellBad cterm=underline

" clang format
let g:clang_format#style_options = {
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "Cpp11",
            \ "AllowShortFunctionsOnASingleLine" : "None",
            \ "BasedOnStyle" : "LLVM"}
" clang format - map to <Leader>cf in C++ code(\cf)
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" ctags - file search
set tags=./tags;/
" ctags list 
nmap <F8> :TagbarToggle<CR>
" TComment
nmap <leader>c :TComment<CR>
nmap <leader>= :TCommentBlock<CR>
" Tcomment visual
vmap <leader>c :TComment<CR>
vmap <leader>= :TCommentBlock<CR>

" tagbar
nmap <F8> :TagbarToggle<CR>

" nerdtree
map <F10> :NERDTreeToggle<CR>
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" Alias
" insert character(space+*char*)
nmap <Space> i_<Esc>r
nmap <S-Enter> O<Esc>j

" YouCompleteMe - Install
" cd ~/.vim/bundle/YouCompleteMe
" ./install.sh --clang-completer
