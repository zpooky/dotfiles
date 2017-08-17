" helper to detect if you are in a dash-list or not
" because it's a bug: https://github.com/plasticboy/vim-markdown/issues/126
function! s:InAListOrNot()
    let the_line = getline(".")
    return the_line =~ '^ *(-|\*|\+) ' ? 1 : 0
endfunction
" then map i_<CR> and o to i_<CR>_<BS> and o<BS> accordingly if yes, and leave as is if not
inoremap <expr> <CR> <SID>InAListOrNot() ? '<CR><BS>' : '<CR>'
nnoremap <expr> o <SID>InAListOrNot() ? 'o<BS>' : 'o'
