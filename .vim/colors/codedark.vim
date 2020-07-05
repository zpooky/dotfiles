" Vim Code Dark (color scheme)
" https://github.com/tomasiser/vim-code-dark
"
" :highlight to see example of all exisiting of how highlight groups will look
" :ColorHighlight highlight in document

scriptencoding utf-8

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name="codedark"

" Highlighting function (inspiration from https://github.com/chriskempson/base16-vim)
if &t_Co >= 256
    let g:codedark_term256=1
elseif !exists("g:codedark_term256")
    let g:codedark_term256=0
endif
fun! <sid>hi(group, fg, bg, attr, sp)
  if !empty(a:fg)
    exec "hi " . a:group . " guifg=" . a:fg.gui . " ctermfg=" . (g:codedark_term256 ? a:fg.cterm256 : a:fg.cterm)
  endif
  if !empty(a:bg)
    exec "hi " . a:group . " guibg=" . a:bg.gui . " ctermbg=" . (g:codedark_term256 ? a:bg.cterm256 : a:bg.cterm)
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  endif
  if !empty(a:sp)
    exec "hi " . a:group . " guisp=" . a:sp.gui
  endif
endfun

" ------------------
" Color definitions:
" ------------------

" Terminal colors (base16):
let s:cterm00 = "00"
let s:cterm03 = "08"
let s:cterm05 = "07"
let s:cterm07 = "15"
let s:cterm08 = "01"
let s:cterm0A = "03"
let s:cterm0B = "02"
let s:cterm0C = "06"
let s:cterm0D = "04"
let s:cterm0E = "05"
if exists('base16colorspace') && base16colorspace == "256"
  let s:cterm01 = "18"
  let s:cterm02 = "19"
  let s:cterm04 = "20"
  let s:cterm06 = "21"
  let s:cterm09 = "16"
  let s:cterm0F = "17"
else
  let s:cterm01 = "00"
  let s:cterm02 = "08"
  let s:cterm04 = "07"
  let s:cterm06 = "07"
  let s:cterm09 = "06"
  let s:cterm0F = "03"
endif

" General appearance colors:
" (some of them may be unused)

let s:cdNone = {'gui': 'NONE', 'cterm': 'NONE', 'cterm256': 'NONE'}
let s:cdFront = {'gui': '#D4D4D4', 'cterm': s:cterm05, 'cterm256': '188'}
let s:cdBack = {'gui': '#1E1E1E', 'cterm': s:cterm00, 'cterm256': '234'}

let s:cdTabCurrent = {'gui': '#1E1E1E', 'cterm': s:cterm00, 'cterm256': '234'}
let s:cdTabOther = {'gui': '#2D2D2D', 'cterm': s:cterm01, 'cterm256': '236'}
let s:cdTabOutside = {'gui': '#252526', 'cterm': s:cterm01, 'cterm256': '235'}

let s:cdLeftDark = {'gui': '#252526', 'cterm': s:cterm01, 'cterm256': '235'}
let s:cdLeftMid = {'gui': '#373737', 'cterm': s:cterm03, 'cterm256': '237'}
let s:cdLeftLight = {'gui': '#3F3F46', 'cterm': s:cterm03, 'cterm256': '238'}

let s:cdPopupFront = {'gui': '#BBBBBB', 'cterm': s:cterm06, 'cterm256': '250'}
let s:cdPopupBack = {'gui': '#2D2D30', 'cterm': s:cterm01, 'cterm256': '236'}
let s:cdPopupHighlightBlue = {'gui': '#073655', 'cterm': s:cterm0D, 'cterm256': '24'}
let s:cdPopupHighlightGray = {'gui': '#3D3D40', 'cterm': s:cterm03, 'cterm256': '237'}

let s:cdSplitLight = {'gui': '#898989', 'cterm': s:cterm04, 'cterm256': '245'}
let s:cdSplitDark = {'gui': '#444444', 'cterm': s:cterm03, 'cterm256': '238'}
let s:cdSplitThumb = {'gui': '#424242', 'cterm': s:cterm04, 'cterm256': '238'}

let s:cdCursorDarkDark = {'gui': '#222222', 'cterm': s:cterm01, 'cterm256': '235'}
let s:cdCursorDark = {'gui': '#51504F', 'cterm': s:cterm03, 'cterm256': '239'}
let s:cdCursorLight = {'gui': '#AEAFAD', 'cterm': s:cterm04, 'cterm256': '145'}
let s:cdSelection = {'gui': '#264F78', 'cterm': s:cterm03, 'cterm256': '24'}
let s:cdLineNumber = {'gui': '#5A5A5A', 'cterm': s:cterm04, 'cterm256': '240'}

let s:cdDiffRedDark = {'gui': '#4B1818', 'cterm': s:cterm08, 'cterm256': '52'}
let s:cdDiffRedLight = {'gui': '#6F1313', 'cterm': s:cterm08, 'cterm256': '52'}
let s:cdDiffRedLightLight = {'gui': '#FB0101', 'cterm': s:cterm08, 'cterm256': '09'}
let s:cdDiffGreenDark = {'gui': '#373D29', 'cterm': s:cterm0B, 'cterm256': '237'}
let s:cdDiffGreenLight = {'gui': '#4B5632', 'cterm': s:cterm09, 'cterm256': '58'}

let s:cdSearchCurrent = {'gui': '#49545F', 'cterm': s:cterm09, 'cterm256': '239'}
let s:cdSearch = {'gui': '#4C4E50', 'cterm': s:cterm0A, 'cterm256': '239'}

" sp note: gui is the only configured
let s:cdViasfora = {'gui': '#ff4500', 'cterm': s:cterm0A, 'cterm256': '239'}
let s:cdVSType = {'gui': '#42c9b0', 'cterm': s:cterm0A, 'cterm256': '239'}

" Syntax colors:

if !exists("g:codedark_conservative")
    let g:codedark_conservative=0
endif

let s:cdGray = {'gui': '#808080', 'cterm': s:cterm04, 'cterm256': '08'}
let s:cdViolet = {'gui': '#646695', 'cterm': s:cterm04, 'cterm256': '60'}
let s:cdBlue = {'gui': '#569CD6', 'cterm': s:cterm0D, 'cterm256': '75'}
let s:cdDarkBlue = {'gui': '#223E55', 'cterm': s:cterm0D, 'cterm256': '73'}
let s:cdLightBlue = {'gui': '#9CDCFE', 'cterm': s:cterm0C, 'cterm256': '117'}
if g:codedark_conservative | let s:cdLightBlue = s:cdFront | endif
let s:cdGreen = {'gui': '#608B4E', 'cterm': s:cterm0B, 'cterm256': '65'}
let s:cdBlueGreen = {'gui': '#4EC9B0', 'cterm': s:cterm0F, 'cterm256': '43'}
let s:cdLightGreen = {'gui': '#B5CEA8', 'cterm': s:cterm09, 'cterm256': '151'}
let s:cdRed = {'gui': '#F44747', 'cterm': s:cterm08, 'cterm256': '203'}
let s:cdOrange = {'gui': '#CE9178', 'cterm': s:cterm0F, 'cterm256': '173'}
let s:cdLightRed = {'gui': '#D16969', 'cterm': s:cterm08, 'cterm256': '167'}
if g:codedark_conservative | let s:cdLightRed = s:cdOrange | endif
let s:cdYellowOrange = {'gui': '#D7BA7D', 'cterm': s:cterm0A, 'cterm256': '179'}
let s:cdYellow = {'gui': '#DCDCAA', 'cterm': s:cterm0A, 'cterm256': '187'}
if g:codedark_conservative | let s:cdYellow = s:cdFront | endif
let s:cdPink = {'gui': '#C586C0', 'cterm': s:cterm0E, 'cterm256': '176'}
if g:codedark_conservative | let s:cdPink = s:cdBlue | endif

" :h attr-lis
" term = terminal
" cterm = color terminal

" cterm=
" - bold
" - underline
" - undercurl         |not always available
" - strikethrough     |not always available
" - reverse
" - inverse           |same as reverse
" - italic
" - standout
" - nocombine         |override attributes instead of combining them
" - NONE              |no attributes used (used to reset it)

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

" tabline {{{
" note: only this groups are supporte in the tabline

" hi TabLine      ctermfg=Black  ctermbg=Green     cterm=NONE
" hi TabLineFill  ctermfg=Black  ctermbg=Green     cterm=NONE
" hi TabLineSel   ctermfg=White  ctermbg=DarkBlue  cterm=NONE
let s:cdTmuxDarkRed = {'gui': '#ac4142', 'cterm': s:cterm08, 'cterm256': '52'}
let s:cdTmuxYellow = {'gui': '#e7c547', 'cterm': s:cterm08, 'cterm256': '52'}
call <sid>hi('TabLine', s:cdFront, s:cdTabOther, 'none', {})
call <sid>hi('TabLineFill', s:cdFront, s:cdTabOutside, 'none', {})
call <sid>hi('TabLineSel', s:cdFront, s:cdTmuxDarkRed, 'bold', {})
"  }}}

" quickscope {{{
"         hi(group, fg, bg, attr, sp)
" let s:cdQuickScopePrimary = s:cdSelection
" let s:cdQuickScopeSecondary = {'gui': '#008000', 'cterm': s:cterm0A, 'cterm256': '239'}
"
call <sid>hi('QuickScopePrimary',{},{}, 'underline', {})
call <sid>hi('QuickScopeSecondary',{},{}, 'underline', {})
"  }}}

" viual studio + viasfora like {{{
" # vim-cpp-enhanced-highlight
" static_assert
" call <sid>hi('cOperator', s:cdViasfora, {}, 'none', {})
" operator=
" call <sid>hi('cppOperator', s:cdViasfora, {}, 'none', {})

" static
" call <sid>hi('cStorageClass', s:cdViasfora, {}, 'none', {})
" constexpr
" call <sid>hi('cppStorageClass', s:cdViasfora, {}, 'none', {})

" todo
" cTODO

" noexcept
" call <sid>hi('cppExceptions', s:cdViasfora, {}, 'none', {})

" enum
" call <sid>hi('cStructure', s:cdViasfora, {}, 'none', {})
" class
" call <sid>hi('cppStructure', s:cdViasfora, {}, 'none', {})

" call <sid>hi('cInclude', s:cdRed, {}, 'none', {})
" call <sid>hi('cIncluded', s:cdRed, {}, 'none', {})

call <sid>hi('cStatement', s:cdViasfora, {}, 'none', {})
call <sid>hi('cConditional', s:cdViasfora, {}, 'none', {})
call <sid>hi('cRepeat', s:cdViasfora, {}, 'none', {})

call <sid>hi('chromaticaStatement', s:cdViasfora, {}, 'none', {})
call <sid>hi('chromaticaIf', s:cdViasfora, {}, 'none', {})
call <sid>hi('chromaticaStatement', s:cdViasfora, {}, 'none', {})

" ## visual studio
call <sid>hi('cType', s:cdVSType, {}, 'none', {})
call <sid>hi('cppType', s:cdVSType, {}, 'none', {})
" }}}
"
" java {{{
call <sid>hi('rustConditional', s:cdViasfora, {}, 'none', {})
" }}}

" java {{{
call <sid>hi('javaStatement', s:cdViasfora, {}, 'none', {})
call <sid>hi('javaConditional', s:cdViasfora, {}, 'none', {})
call <sid>hi('javaRepeat', s:cdViasfora, {}, 'none', {})

call <sid>hi('javaType', s:cdVSType, {}, 'none', {})
" }}}

" Markdown {{{
" #List item prefix(-)
call <sid>hi('mkdListItem', s:cdViasfora, {}, 'bold', {})
" ##URL
call <sid>hi('mkdInlineURL', s:cdYellow, {}, 'none', {})
" }}}

" Diff {{{
call <sid>hi('diffRemoved', s:cdRed, {}, 'none', {})
call <sid>hi('DiffDelete', {}, s:cdRed, 'none', {})
call <sid>hi('diffAdded', s:cdGreen, {}, 'none', {})
call <sid>hi('DiffAdd', {}, s:cdGreen, 'none', {})
call <sid>hi('DiffChange', {}, s:cdDiffRedDark, 'none', {})
call <sid>hi('DiffText', {}, s:cdDiffRedLight, 'none', {})
" }}}

" ALE {{{
call <sid>hi('ALEErrorSign', s:cdRed, {}, 'bold', {})
call <sid>hi('ALEWarningSign', s:cdYellowOrange, {}, 'none', {})
" }}}

" Coc {{{
" CocErrorSign   xxx ctermfg=9 guifg=#ff0000
" CocWarningSign xxx ctermfg=130 guifg=#ff922b
" CocSelectedText xxx ctermfg=9 guifg=#fb4934
hi clear CocListFgBlack
hi clear CocListBlackBlack
hi clear CocUnderline
hi clear CocErrorHighlight
hi clear CocWarningHighlight
hi clear CocInfoHighlight
hi clear CocHintHighlight
" }}}

" Spell {{{
" TODO
call <sid>hi('SpellBad', s:cdRed, s:cdNone, 'undercurl', {})
call <sid>hi('SpellCap', s:cdNone, s:cdNone, 'undercurl', {})
call <sid>hi('SpellLocal', s:cdNone, s:cdNone, 'undercurl', {})
" }}}

" Misc {{{
call <sid>hi('bbUnmatched', s:cdRed, s:cdNone, 'undercurl', {})
" }}}

" vim-illuminated {{{
" call <sid>hi('SpIlluminated', {}, s:cdLeftMid, 'none', {})
call <sid>hi('SpIlluminated',{},s:cdDiffGreenDark, 'none', {})
" }}}
"

" JavaScript: {{{
call <sid>hi('jsVariableDef', s:cdLightBlue, {}, 'none', {})
call <sid>hi('jsFuncArgs', s:cdLightBlue, {}, 'none', {})
call <sid>hi('jsRegexpString', s:cdLightRed, {}, 'none', {})
call <sid>hi('jsThis', s:cdBlue, {}, 'none', {})

call <sid>hi('javaScriptConditional', s:cdViasfora, {}, 'none', {})
call <sid>hi('javaScriptStatement', s:cdViasfora, {}, 'none', {}) "return

call <sid>hi('javaScriptReserved', s:cdBlue, {}, 'none', {}) "const, export, import
call <sid>hi('javaScriptOperator', s:cdBlue, {}, 'none', {}) "new
call <sid>hi('javaScriptException', s:cdBlue, {}, 'none', {}) "throw

" call <sid>hi('javaScriptStringT', s:cdBlue, {}, 'none', {}) " this is the '`' enclose string
" call <sid>hi('javaScriptEmbed', s:cdViasfora, {}, 'none', {}) "the variable part `as ${variable} was`
" }}}

" {{{
" hi semshiLocal           ctermfg=209 guifg=#ff875f
" hi semshiGlobal          ctermfg=214 guifg=#ffaf00
" hi semshiImported        ctermfg=214 guifg=#ffaf00 cterm=bold gui=bold
" hi semshiParameter       ctermfg=75  guifg=#5fafff
" hi semshiParameterUnused ctermfg=117 guifg=#87d7ff cterm=underline gui=underline
" hi semshiFree            ctermfg=218 guifg=#ffafd7
" hi semshiBuiltin         ctermfg=207 guifg=#ff5fff
" hi semshiAttribute       ctermfg=49  guifg=#00ffaf
" hi semshiSelf            ctermfg=249 guifg=#b2b2b2
" hi semshiUnresolved      ctermfg=226 guifg=#ffff00 cterm=underline gui=underline
" hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#d7005f
"
" hi semshiErrorSign       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
" hi semshiErrorChar       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
" sign define semshiError text=E> texthl=semshiErrorSign
"}}}

" Vim editor colors
"    <sid>hi(GROUP, FOREGROUND, BACKGROUND, ATTRIBUTE, SPECIAL)
call <sid>hi('Normal', s:cdFront, s:cdBack, 'none', {})
call <sid>hi('ColorColumn', {}, s:cdCursorDarkDark, 'none', {})
call <sid>hi('Cursor', s:cdCursorDark, s:cdCursorLight, 'none', {})
call <sid>hi('CursorLine', {}, s:cdCursorDarkDark, 'none', {})
call <sid>hi('Directory', s:cdBlue, s:cdBack, 'none', {})
call <sid>hi('EndOfBuffer', s:cdLineNumber, s:cdBack, 'none', {})
call <sid>hi('ErrorMsg', s:cdRed, s:cdBack, 'none', {})
call <sid>hi('VertSplit', s:cdSplitDark, s:cdBack, 'none', {})
call <sid>hi('Folded', s:cdLeftLight, s:cdLeftDark, 'underline', {})
call <sid>hi('FoldColumn', s:cdLineNumber, s:cdBack, 'none', {})
call <sid>hi('SignColumn', {}, s:cdBack, 'none', {})
call <sid>hi('IncSearch', s:cdNone, s:cdSearchCurrent, 'none', {})
call <sid>hi('LineNr', s:cdLineNumber, s:cdBack, 'none', {})
call <sid>hi('CursorLineNr', s:cdPopupFront, s:cdBack, 'none', {})
call <sid>hi('MatchParen', s:cdNone, s:cdCursorDark, 'none', {})
call <sid>hi('ModeMsg', s:cdFront, s:cdLeftDark, 'none', {})
call <sid>hi('MoreMsg', s:cdFront, s:cdLeftDark, 'none', {})
call <sid>hi('NonText', s:cdLineNumber, s:cdBack, 'none', {})
call <sid>hi('Pmenu', s:cdPopupFront, s:cdPopupBack, 'none', {})
call <sid>hi('PmenuSel', s:cdPopupFront, s:cdPopupHighlightBlue, 'none', {})
call <sid>hi('PmenuSbar', {}, s:cdPopupHighlightGray, 'none', {})
call <sid>hi('PmenuThumb', {}, s:cdPopupFront, 'none', {})
call <sid>hi('Question', s:cdBlue, s:cdBack, 'none', {})
call <sid>hi('Search', s:cdNone, s:cdSearch, 'none', {})
call <sid>hi('SpecialKey', s:cdBlue, s:cdNone, 'none', {})
call <sid>hi('StatusLine', s:cdFront, s:cdLeftMid, 'none', {})
call <sid>hi('StatusLineNC', s:cdFront, s:cdLeftDark, 'none', {})
call <sid>hi('Title', s:cdNone, s:cdNone, 'bold', {})
call <sid>hi('Visual', s:cdNone, s:cdSelection, 'none', {})
call <sid>hi('VisualNOS', s:cdNone, s:cdSelection, 'none', {})
call <sid>hi('WarningMsg', s:cdOrange, s:cdBack, 'none', {})
call <sid>hi('WildMenu', s:cdNone, s:cdSelection, 'none', {})

call <sid>hi('Comment', s:cdGreen, {}, 'none', {})

call <sid>hi('Constant', s:cdBlue, {}, 'none', {})
call <sid>hi('String', s:cdOrange, {}, 'none', {})
call <sid>hi('Character', s:cdOrange, {}, 'none', {})
call <sid>hi('Number', s:cdLightGreen, {}, 'none', {})
call <sid>hi('Boolean', s:cdBlue, {}, 'none', {})
call <sid>hi('Float', s:cdLightGreen, {}, 'none', {})

call <sid>hi('Identifier', s:cdLightBlue, {}, 'none', {})
call <sid>hi('Function', s:cdYellow, {}, 'none', {})

call <sid>hi('Statement', s:cdPink, {}, 'none', {})
call <sid>hi('Conditional', s:cdPink, {}, 'none', {})
call <sid>hi('Repeat', s:cdPink, {}, 'none', {})
call <sid>hi('Label', s:cdPink, {}, 'none', {})
call <sid>hi('Operator', s:cdFront, {}, 'none', {})
call <sid>hi('Keyword', s:cdPink, {}, 'none', {})
call <sid>hi('pythonOperator', s:cdPink, {}, 'none', {})
call <sid>hi('Exception', s:cdPink, {}, 'none', {})

call <sid>hi('PreProc', s:cdPink, {}, 'none', {})
call <sid>hi('Include', s:cdPink, {}, 'none', {})
call <sid>hi('Define', s:cdPink, {}, 'none', {})
call <sid>hi('Macro', s:cdPink, {}, 'none', {})
call <sid>hi('PreCondit', s:cdPink, {}, 'none', {})

call <sid>hi('Type', s:cdBlue, {}, 'none', {})
call <sid>hi('StorageClass', s:cdBlue, {}, 'none', {})
call <sid>hi('Structure', s:cdBlue, {}, 'none', {})
call <sid>hi('Typedef', s:cdBlue, {}, 'none', {})

call <sid>hi('Special', s:cdFront, {}, 'none', {})
call <sid>hi('SpecialChar', s:cdFront, {}, 'none', {})
call <sid>hi('Tag', s:cdFront, {}, 'none', {})
call <sid>hi('Delimiter', s:cdFront, {}, 'none', {})
call <sid>hi('SpecialComment', s:cdGreen, {}, 'none', {})
call <sid>hi('Debug', s:cdFront, {}, 'none', {})

call <sid>hi('Underlined', s:cdNone, {}, 'underline', {})
call <sid>hi("Conceal", s:cdFront, s:cdBack, 'none', {})

call <sid>hi('Ignore', s:cdFront, {}, 'none', {})

call <sid>hi('Error', {}, s:cdRed, 'bold', s:cdRed)

call <sid>hi('Todo', s:cdNone, s:cdLeftMid, 'none', {})

" HTML:
call <sid>hi('htmlTag', s:cdGray, {}, 'none', {})
call <sid>hi('htmlEndTag', s:cdGray, {}, 'none', {})
call <sid>hi('htmlTagName', s:cdBlue, {}, 'none', {})
call <sid>hi('htmlSpecialTagName', s:cdBlue, {}, 'none', {})
call <sid>hi('htmlArg', s:cdLightBlue, {}, 'none', {})

" CSS:
call <sid>hi('cssBraces', s:cdFront, {}, 'none', {})
call <sid>hi('cssInclude', s:cdPink, {}, 'none', {})
call <sid>hi('cssTagName', s:cdYellowOrange, {}, 'none', {})
call <sid>hi('cssClassName', s:cdYellowOrange, {}, 'none', {})
call <sid>hi('cssPseudoClass', s:cdYellowOrange, {}, 'none', {})
call <sid>hi('cssPseudoClassId', s:cdYellowOrange, {}, 'none', {})
call <sid>hi('cssPseudoClassLang', s:cdYellowOrange, {}, 'none', {})
call <sid>hi('cssIdentifier', s:cdYellowOrange, {}, 'none', {})
call <sid>hi('cssProp', s:cdLightBlue, {}, 'none', {})
call <sid>hi('cssDefinition', s:cdLightBlue, {}, 'none', {})
call <sid>hi('cssAttr', s:cdOrange, {}, 'none', {})
call <sid>hi('cssAttrRegion', s:cdOrange, {}, 'none', {})
call <sid>hi('cssColor', s:cdOrange, {}, 'none', {})
call <sid>hi('cssFunction', s:cdOrange, {}, 'none', {})
call <sid>hi('cssFunctionName', s:cdOrange, {}, 'none', {})
call <sid>hi('cssVendor', s:cdOrange, {}, 'none', {})
call <sid>hi('cssValueNumber', s:cdOrange, {}, 'none', {})
call <sid>hi('cssValueLength', s:cdOrange, {}, 'none', {})
call <sid>hi('cssUnitDecorators', s:cdOrange, {}, 'none', {})

" Ruby:
call <sid>hi('rubyClassNameTag', s:cdBlueGreen, {}, 'none', {})

" Golang:
call <sid>hi('goPackage', s:cdBlue, {}, 'none', {})
call <sid>hi('goImport', s:cdBlue, {}, 'none', {})
call <sid>hi('goVar', s:cdBlue, {}, 'none', {})
call <sid>hi('goConst', s:cdBlue, {}, 'none', {})
call <sid>hi('goStatement', s:cdPink, {}, 'none', {})
call <sid>hi('goType', s:cdBlue, {}, 'none', {})
call <sid>hi('goSignedInts', s:cdBlue, {}, 'none', {})
call <sid>hi('goUnsignedInts', s:cdBlue, {}, 'none', {})
call <sid>hi('goFloats', s:cdBlue, {}, 'none', {})
call <sid>hi('goComplexes', s:cdBlue, {}, 'none', {})
call <sid>hi('goBuiltins', s:cdYellow, {}, 'none', {})
call <sid>hi('goBoolean', s:cdBlue, {}, 'none', {})
call <sid>hi('goPredefinedIdentifiers', s:cdBlue, {}, 'none', {})
call <sid>hi('goTodo', s:cdGreen, {}, 'none', {})
call <sid>hi('goDeclaration', s:cdBlue, {}, 'none', {})
call <sid>hi('goDeclType', s:cdBlue, {}, 'none', {})
call <sid>hi('goTypeDecl', s:cdBlue, {}, 'none', {})
call <sid>hi('goTypeName', s:cdBlueGreen, {}, 'none', {})
call <sid>hi('goVarAssign', s:cdLightBlue, {}, 'none', {})
call <sid>hi('goVarDefs', s:cdLightBlue, {}, 'none', {})
call <sid>hi('goReceiver', s:cdFront, {}, 'none', {})
call <sid>hi('goReceiverType', s:cdDarkBlue, {}, 'none', {})
call <sid>hi('goFunctionCall', s:cdYellow, {}, 'none', {})
call <sid>hi('goMethodCall', s:cdYellow, {}, 'none', {})
call <sid>hi('goSingleDecl', s:cdLightBlue, {}, 'none', {})
