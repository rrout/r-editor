


function! ECHO(szFuncName, ...)
    let szTrace = a:szFuncName
    let paramNum = a:0
    let last = 0
    if paramNum>0
        let szTrace .= ':  '
    endif
    for i in range(paramNum+1)
        if type( eval('a:'.string(i)) ) == 1 && last == 0
            let szTrace = szTrace .''. eval('a:'.string(i)).''
            let last=1
        else
            let szTrace = szTrace .''. string(eval('a:'.string(i))).'|  '
            let last=0
        endif
    endfor
    echon szTrace
    echoerr ""
endfunc


if !exists('cmd_quit')
    let cmd_quit = '<leader><C-J>'
endif
exec ":noremap  ". g:cmd_quit  ." <ESC>:q <CR>"
exec ":inoremap ". g:cmd_quit  ." <ESC>:q <CR>"

if !exists('cmd_save_file')
    let cmd_save_file = '<leader><C-K>'
endif
exec ":noremap  ". g:cmd_save_file ." <ESC>:silent write <CR>"
exec ":inoremap ". g:cmd_save_file ." <ESC>:silent write <CR>"


if !exists('insert_cfile_header_directive')
    let insert_cfile_header_directive = '<leader><C-F><C-H>'
endif
if !exists('toggle_paste_mode')
    let toggle_paste_mode = '<leader><F4>'
endif


function! Header()
    let header = substitute( expand("%:t"), '\.', '_', "g")
    let header = substitute( header, '.*', '__&__', "g")
    let header = substitute( header, '.', '\U&', "g")
    let ifndef = substitute( header, '.*', '#ifndef &', "g")
    let define = substitute( header, '.*', '#define &', "g")
    let cline = line('.')
            "echoerr header
    call append(cline, define)
    call append(cline, ifndef)
endfun

exec "noremap  ". g:insert_cfile_header_directive ." <ESC>:call Header() <CR>"
exec "inoremap ". g:insert_cfile_header_directive ." <ESC>:call Header() <CR>"



let g:is_paste=0
function! Paste_Nopaste()
    if( g:is_paste == 0 )
        exe "set paste"
        echo "paste"
        let g:is_paste=1
            "se im
            "inoremap <ESC> <C-L> :set im!<CR>
            "map <C-L> set im!<CR><c-o>:echo <CR>

    else
        exe "set nopaste"
        let g:is_paste=0
        echo "nopaste"

    endif
endfun
exec ":map   ". g:toggle_paste_mode ." <ESC>:call Paste_Nopaste()<CR> "
exec ":imap  ". g:toggle_paste_mode ." <ESC>:call Paste_Nopaste()<CR> i"



if !exists('cmd_full_find_replace')
    let cmd_full_find_replace = '<leader><C-J>'
endif
if !exists('cmd_line_find_replace')
    let cmd_line_find_replace = '<leader><C-K>'
endif
if !exists('cmd_select_find_replace')
    let cmd_select_find_replace = '<leader><C-L>'
endif

exec ":map ". g:cmd_full_find_replace ." :%s/<C-R>=expand(\"<cword>\")<CR>/<C-R>=expand(\"<cword>\")<CR>/gc"
exec ":map ". g:cmd_line_find_replace ." :s/<C-R>=expand(\"<cword>\")<CR>/<C-R>=expand(\"<cword>\")<CR>/gc"
exec ":map ". g:cmd_select_find_replace ." :'<,'>s/<C-R>=expand(\"<cword>\")<CR>/<C-R>=expand(\"<cword>\")<CR>/gc"

:fun! UnSetIndent()
  stopinsert
  set noautoindent
  set nosmartindent
  startinsert
endfun
":noremap  <F11> <ESC>:call UnSetIndent()<CR>
":noremap! <F11> <ESC>:call UnSetIndent()<CR>

:fun! SetIndent()
  stopinsert
  set autoindent
  set smartindent
  startinsert
endfun
":noremap  <F12> <ESC>:call SetIndent()<CR>
":noremap! <F12> <ESC>:call SetIndent()<CR>

:fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echo getline(search("^[^ \t#/]\\{2}", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun

"TODO delay when i ESC
"inoremap <expr> ^[k ((pumvisible())?("\<up>"):("k"))
"inoremap <expr> ^[j ((pumvisible())?("\<down>"):("j"))
inoremap <expr> <C-k> ((pumvisible())?("\<up>"):("\<C-k>"))
inoremap <expr> <C-j> ((pumvisible())?("\<down>"):("\<C-j>"))

:fun! AlignEqual()

        let sline = line("'<")
        let eline = line("'>")
        let cline = line(".")
        if ( eline != cline )
            return
        endif
        let len = 0
        while( cline >= sline )
            let clen = strlen( substitute( getline(cline), ' *=.*', '', "g"))
            if( clen > len )
                let len = clen
            endif
            let cline = cline -1
        endwhile

        let cline = sline
        while( cline <= eline )
            let leftLine  = substitute(substitute( getline(cline), '\(.*\) *[><=!:]=* *\(.*\)', '\1', "g"),' *$','',"g")
            let operator  = substitute(substitute( getline(cline), '\([><=!:][=]*\).*', '\1', "g"), '\([^><=!]\)' ,'', 'g')
            let rightLine = substitute( getline(cline), '\(.*\) *[><=!:]=* *\(.*\)', '\2', "g")
            let fill=' ' | while strlen(leftLine) < len | let leftLine=leftLine.fill | endwhile
            if ( match(getline(cline), "=") > 0 )
                let lineFull = leftLine." ".operator." ".rightLine
                call setline(cline,lineFull)
            endif
            let cline = cline+1
        endwhile

endfun

":noremap <C-Z> :call AlignEqual()<CR>



if !exists('cmd_insert_function_header')
    let cmd_insert_function_header = '<leader><C-F><C-U>'
endif

:fun! Headers()

        let sline = line("'<")
        let eline = line("'>")
        let cline = line(".")
        if ( eline != cline )
            return
        endif

        let funDec = ""
        let nnum = sline-1
        if sline == eline
            let funDec = getline(sline)
        else
            while( sline <= eline )
                 let funDec = funDec.getline(sline)
                 let sline = sline +1
            endwhile
        endif

        let nline = funDec
        let args = substitute(nline, '.*(', "", "g")
        let rfname =  substitute(nline,' *(.*',"", "g")
        let fname =  substitute(rfname,'.* \(.*\)','\1', "g")
        if  match(fname, "*") == 0

            let fname = substitute(fname, '.*\*', "", "g")
            let star = "*"
        else
            let star = ""
        endif

        let ret =  substitute(rfname,'.* ',"", "g")
        let ret =  substitute(rfname, ret ,"", "g")
        call append(nnum, " */")
        call append(nnum, " * @return  : ".ret.star)

        let args = substitute(args, '\(.*\)).*', '\1', "g")
        let args = substitute(args, '^', " ,", "g")
        let ac = strlen(substitute(args, '[^,]', "", "g"))
        let clen = 0
        let lcount = 0
        while( match(args, ",") >=0)
            let param = substitute(args, '\(.*\),\(.*\)', '\2', "g")
            let args = substitute(args, '\(.*\),\(.*\)', '\1', "g")
            let param = substitute(param, '^.*  *\**', "", "")
            let txt = " * @param   : ".param
            if ( clen < strlen(txt))
                let clen=strlen(txt)
            endif
            let lcount = lcount + 1
            "let fill=' ' | while strlen(txt) < 30 | let txt=txt.fill | endwhile
            "let txt=txt."-  "
            let ac = ac - 1
            call append(nnum,txt)
        endwhile
            "call append(nnum, " * @ingroup :")
        call append(nnum,    "/* @brief   : ".fname)

            "Align the - letter
        let nnum = nnum+2
        let cnt = 0
        while( cnt < lcount)
            let leftLine = getline(nnum)
            let fill=' ' | while strlen(leftLine) < clen | let leftLine=leftLine.fill | endwhile
            let lineFull = leftLine." -  ". substitute(leftLine, '.*: *','',"g")
            call setline(nnum,lineFull)
            let nnum = nnum+1
            let cnt = cnt +1
        endwhile

endfun
exec ":noremap " g:cmd_insert_function_header ." :call Headers()<CR>"


if !exists(':cmd_align_equal')
    let :cmd_align_equal = '<leader><C-F><C-E>'
endif
:fun! ExpAlign()
        let sline = line("'<")
        let eline = line("'>")
        let cline = line(".")
        if ( eline != cline )
            return
        endif

        let cline = sline
        let len = strlen(substitute(getline(cline), '\(.*[^=]=*[^(]*(\).*','\1',"g"))
        let cline = cline +1
        while( cline <= eline )
            let rightLine = substitute(getline(cline), ' *', '', 'g')
            let fill=' ' | while strlen(fill) < len | let fill=fill.' ' | endwhile
            call setline(cline,fill.rightLine)
            let cline = cline +1
        endwhile

endfun
exec ":noremap " g:cmd_align_equal ." :call ExpAlign()<CR>"


"autocmd CursorHold * call Timer()
"function! Timer()
    "call feedkeys("f\e")
    "echo "RUNNING"
"endfunction

let g:ProgressCount=1
func GtagsProgressBar(timer)
    let g:ProgressCount = g:ProgressCount +1

    if g:ProgressCount >= 3
        let g:ProgressCount = 0
    endif
    let ProgressChar = ["|", "/", "--", "\\"]

    echo '[ Searching ] '. ProgressChar[ g:ProgressCount ]

endfunc
"let timer = timer_start(1000, 'GtagsProgressBar', {'repeat': 10})


function! Auto_Highlight_Cword()
  exe "let @/='\\<".expand("<cword>")."\\>'"
endfunction

function! Auto_Highlight_Toggle()
  if exists("#CursorHold#*")
    au! CursorHold *
    let @/=''
  else
    set hlsearch
    set updatetime=700
    au! CursorHold * nested call Auto_Highlight_Cword()
  endif
endfunction



if !exists('cmd_highlight_word')
    let cmd_highlight_word = '<leader><C-@>'
endif
if !exists('cmd_highlight_word_alt')
    let cmd_highlight_word_alt = '<leader><C-@>'
endif

let g:MatchGroup= [
        \{
        \   "MatchName":"Name1",
        \   "MatchColor":"cterm=bold  ctermbg=136 ctermfg=255",
        \   "MatchId":0
        \},
        \{
        \   "MatchName":"Name2",
        \   "MatchColor":"cterm=bold  ctermbg=24 ctermfg=255",
        \   "MatchId":0
        \},
        \{
        \   "MatchName":"Name3",
        \   "MatchColor":"cterm=bold  ctermbg=22 ctermfg=255",
        \   "MatchId":0
        \},
        \{
        \   "MatchName":"Name4",
        \   "MatchColor":"cterm=bold  ctermbg=52 ctermfg=255",
        \   "MatchId":0
        \},
        \{
        \   "MatchName":"Name5",
        \   "MatchColor":"cterm=bold  ctermbg=103 ctermfg=255",
        \   "MatchId":0
        \},
        \{
        \   "MatchName":"Name6",
        \   "MatchColor":"cterm=bold  ctermbg=55 ctermfg=255",
        \   "MatchId":0
        \},
        \{
        \   "MatchName":"Name7",
        \   "MatchColor":"cterm=bold  ctermbg=168 ctermfg=255",
        \   "MatchId":0
        \},
        \{
        \   "MatchName":"Name8",
        \   "MatchColor":"cterm=bold  ctermbg=244 ctermfg=255",
        \   "MatchId":0
        \},
        \{
        \   "MatchName":"Name9",
        \   "MatchColor":"cterm=bold  ctermbg=26 ctermfg=255",
        \   "MatchId":0
        \}
    \]
let g:MatchIndex=0
function! Highlight_Match()
    try

        let search_word = expand("<cword>")

        let matches = getmatches()
        let match_idx=match(matches, search_word)
        if match_idx != -1
            let mg = matches[match_idx]
            call matchdelete(mg.id)

            let md = match(g:MatchGroup, mg.group)
            let g:MatchGroup[md].MatchId = 0
            "call ECHO("DATA", g:MatchGroup, getmatches(), md)
            let @/=""
            return
        endif

        let mg = g:MatchGroup[g:MatchIndex]
        exec "highlight ".mg.MatchName. " ". mg.MatchColor

        let mg.MatchId = matchadd(mg.MatchName, "\\\<".search_word."\\\>")
        let @/=search_word
        let @/= "\\<".search_word."\\>"
        let g:MatchIndex+=1
        if g:MatchIndex >= len(g:MatchGroup)
            let g:MatchIndex =0
        endif
        let mg = g:MatchGroup[g:MatchIndex]
        if mg.MatchId != 0
            call matchdelete(mg.MatchId)
            let mg.MatchId=0
        endif
    catch
        "call ECHO("HIGHLIGHT",  "====INDEX=======", g:MatchIndex, "======GROUP=====", g:MatchGroup, "=======GETMATCHES======", getmatches())
    endtry

endfunction

exec "noremap ". g:cmd_highlight_word ." :call Highlight_Match()<CR>"
exec "noremap ". g:cmd_highlight_word_alt ." :call Highlight_Match()<CR>"
exec "noremap <2-LeftMouse> :call Highlight_Match()<CR>"


function! ExecuteCommand()
    let cmd = getline('.')
    execute "!".cmd
endfunction
noremap <C-E><C-E> :call ExecuteCommand()<CR>

function! File_Header()
    call append(line(".")-2, "/*")
    call append(line(".")-2, " * FILENAME       :  " . expand("%:t") )
    call append(line(".")-2, " * DESCRIPTION    :  ")
    call append(line(".")-2, " * Author         :  Team")
    call append(line(".")-2, " * Date           :  28-12-2013")
    call append(line(".")-2, " * Copyright (c) All rights reserved.")
    call append(line(".")-2, " */")
endfunction
:noremap   ^[q  <ESC> :call File_Header() <CR>
:inoremap  ^[q  <ESC> :call File_Header() <CR>


function! Fun_Header()
    let line = line(".")-2
    call append(line, "/*")
    let save_cursor = getpos(".")
    call append(line+1, " * Name   : ".expand("<cword>") )
    call append(line+2, " * Desc   : ".expand("<cword>") )
    call append(line+3, " * Params : void ")
    call append(line+4, " * Return : void ")
    call append(line+5, " */")
    call setpos('.', save_cursor)
    exe "normal! A"
endfunction
:noremap  ^[w  <ESC> :call Fun_Header() <CR>
:inoremap ^[w  <ESC> :call Fun_Header() <CR>

function! IMoveUp()
    call cursor( line('.')-1, 0)
endfunction

function! IMoveDown()
    call cursor( line('.')+1, 0)
endfunction


:fun! OpenFile()
    set path=.,/usr/include/,/usr/local/include/,./**,../**,../../**
    execute "normal! gf"
    set path=.
endfun
":noremap gf :call OpenFile()<CR>


:fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echo getline(search("^[^ \t#/]\\{2}", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun



let g:lock=0
let g:curline=""
function! Printf()
    if ( g:lock == 0 )
        let g:curline = getline('.')
        let g:lock=1
        call setline('.',"")
    else
        let string = getline('.')
        call setline('.', "printf(\"[ ]". string . "=%\\n\"," . string.");")
        let g:lock=0
    endif
endfunction

":noremap  ^[o <ESC>:call Printf() <CR>i
":inoremap ^[o <ESC>:call Printf() <CR>i

let g:search_pattern=""
function! LineSearch()
    call search("\\%".line('.')."l".g:search_pattern)
endfunction
function! LineSearchInput()
    let g:search_pattern = input("_/")
    call LineSearch()
endfunction
noremap ^[\     :call LineSearchInput() <CR>
inoremap ^[\    <ESC>:call LineSearchInput() <CR>
inoremap ^[^[./ <ESC>:call LineSearchInput() <CR>
noremap ^[^[./  :call LineSearchInput() <CR>

inoremap ^[n    <ESC>:call LineSearch() <CR>
noremap ^[n     :call LineSearch() <CR>

inoremap  ^[q  <C-R>=ListMonths()<CR>


