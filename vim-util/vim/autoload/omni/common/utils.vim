" Description: Omni completion utils
" Maintainer:  Vissale NEANG
" Last Change: 26 sept. 2007

" For sort numbers in list
function! omni#common#utils#CompareNumber(i1, i2)
    let num1 = eval(a:i1)
    let num2 = eval(a:i2)
    return num1 == num2 ? 0 : num1 > num2 ? 1 : -1
endfunc

" TagList function calling the vim taglist() with try catch
" The only throwed exception is 'TagList:UserInterrupt'
" We also force the noignorecase option to avoid linear search when calling
" taglist()
function! omni#common#utils#TagList(szTagQuery)
    let result = []
    let bUserIgnoreCase = &ignorecase
    " Forcing noignorecase search => binary search can be used in taglist()
    " if tags in the tag file are sorted
    if bUserIgnoreCase
        set noignorecase
    endif
    try
        let result = taglist(a:szTagQuery)
    catch /^Vim:Interrupt$/
        " Restoring user's setting
        if bUserIgnoreCase
            set ignorecase
        endif
        throw 'TagList:UserInterrupt'
    catch
        "Note: it seems that ctags can generate corrupted files, in this case
        "taglist() will fail to read the tagfile and an exception from
        "has_add() is thrown
    endtry

    " Restoring user's setting
    if bUserIgnoreCase
        set ignorecase
    endif
    return result
endfunc




"
" Display error message.
"
function! s:Error(msg)
    echohl WarningMsg |
           \ echomsg 'Error: ' . a:msg |
           \ echohl None
endfunction
"
" Trim options to avoid errors.
"
function! s:TrimOption(option)
    let l:option = ''
    let l:length = strlen(a:option)
    let l:i = 0

    while l:i < l:length
        let l:c = a:option[l:i]
        if l:c !~ '[cenpquv]'
            let l:option = l:option . l:c
        endif
        let l:i = l:i + 1
    endwhile
    return l:option
endfunction

if !exists("g:Gtags_Shell_Quote_Char")
    if has("win32") || has("win16") || has("win95")
        let g:Gtags_Shell_Quote_Char = '"'
    else
        let g:Gtags_Shell_Quote_Char = "'"
    endif
endif









function! omni#common#utils#GetGtag(option, pattern)
    " Execute global(1) command and write the result to a temporary file.
    let l:option = ''
    let l:result = ''

    let l:option = l:option . '--result=gtags' 
    let l:option = l:option . ' -'. s:TrimOption(a:option)
	let l:cmd = 'global ' . l:option . 'e ' . g:Gtags_Shell_Quote_Char . a:pattern . g:Gtags_Shell_Quote_Char 

    "echoerr "CMD = ".l:cmd

    let l:result = system(l:cmd)
	"echoerr "RES =".l:result
    if v:shell_error != 0
        if v:shell_error != 0
            if v:shell_error == 2
                call s:Error('invalid arguments. (gtags.vim requires GLOBAL 5.7 or later)')
            elseif v:shell_error == 3
                call s:Error('GTAGS not found.')
            else
                call s:Error('global command failed. command line: ' . l:cmd)
            endif
        endif
        return
    endif
    if l:result == '' 
        if l:option =~ 'f'
            call s:Error('Tag not found in ' . a:pattern . '.')
        elseif l:option =~ 'P'
            call s:Error('Path which matches to ' . a:pattern . ' not found.')
        elseif l:option =~ 'g'
            call s:Error('Line which matches to ' . a:pattern . ' not found.')
        else
            call s:Error('Tag which matches to ' . g:Gtags_Shell_Quote_Char . a:pattern . g:Gtags_Shell_Quote_Char . ' not found.')
        endif
        return
    endif

	"call ECHO ( "Result:" , l:result)
	return l:result

endfunction



"{'cmd': '/^struct A$/', 'static': 1, 'name': 'A', 'kind': 's', 'filename': '.\test.c'}
"{'cmd': '/^    struct B$/', 'static': 1, 'name': 'A::B', 'kind': 's', 'struct': 'A', 'access': 'public', 'filename': '.\test.c'}


" Debug functions
"function! DisplaySetup()
    "call add(s:Stack, copy(s:Tag))
    "let s:TagStack.TagStack=copy(s:Stack)
    "call add(s:Window, copy(s:TagStack) )
    "let s:Window[0].TagStack[0].TagName="TEST"
    "echo  "Tag name=". s:Window[0].TagStack[0].TagName
"endfunction




function! omni#common#utils#GetGtagFileList(gtags)
	let gTag={"cmd":"", "static":"", "name":"","kind":"", "struct":"", "access":"", "filename":"" }
	let gTagList=[]
	let tags = []
	let tags=split(a:gtags, "\n")
	"echon tags
	for tag in tags
		let words = split(tag, '\t')
		""call ECHOER(" FILE LIST", words)
		if len(words) < 5 
			continue
		endif
		let dirs=split(words[0], '/')

		if len(dirs) == 1

			let tg = copy(gTag)
			"let tg.name=substitute(words[0], '', '', 'g')
			let tg.name=words[0]
			let tg.filename=words[0]
			let tg.kind="g"
			let tg.static="1"
			let tg.struct=words[0]
			let tg.access="public"
			let tg.cmd=words[0]
			call add(gTagList, tg)
		elseif len(dirs) > 1
			let path = words[0]
			let path=substitute(path, '^.*/', '', 'g')
			"echoerr "FILE:". path
			let tg = copy(gTag)
			let tg.name=path
			let tg.filename=path
			let tg.kind="g"
			let tg.static="1"
			let tg.struct=path
			let tg.access="public"
			let tg.cmd=path
			call add(gTagList, tg)
		else
			let path = words[0]
			for dir in dirs
				let path=substitute(path, '^[^/]\+/', '', 'g')
				"echoerr "FILE:". path
				let tg = copy(gTag)
				let tg.name=path
				let tg.filename=path
				let tg.kind="g"
				let tg.static="1"
				let tg.struct=path
				let tg.access="public"
				let tg.cmd=path
				call add(gTagList, tg)
			endfor
		endif
	endfor
	return gTagList
endfunc

function! omni#common#utils#GetGtagList(gtags)
	let gTag={"cmd":"", "static":"", "name":"","kind":"", "struct":"", "access":"", "filename":"" }
	let gTagList=[]
	let tags = []
	let tags=split(a:gtags, "\n")
	"echon tags
	for tag in tags
		let words = split(tag, '\t')
		"echon words
		"echoerr "WORDS"
		if len(words) < 5 
			continue
		endif
		let types=split(words[3],"|")
		"echoerr string(types). "LEN".len(types)
		if len(types) < 3 
			continue
		endif
		let tg = copy(gTag)
		let tg.name=words[2]
		let tg.filename=words[0]
		let tg.kind="m"
		let tg.static="1"
		let tg.struct=types[2]
		let tg.access="public"
		let tg.cmd=words[4]
		call add(gTagList, tg)
	endfor
	return gTagList
endfunc

"^yy$[{'cmd': '/^struct Y yy;$/', 'typeref': 'struct:Y', 'static': 0, 'name': 'yy', 'kind': 'v', 'filename': '.\test.c'}]
"^Y$[{'cmd': '/^struct Y$/', 'static': 1, 'name': 'Y', 'kind': 's', 'filename': '.\test.c'}]
function! omni#common#utils#GetGtagStruct(gtags)
	let gTag={"cmd":"", "static":"", "name":"","kind":"", "filename":"" }
	let gTagList=[]
	let tags = []
	let tags=split(a:gtags, "\n")
	"echon a:gtags
	for tag in tags
		let words = split(tag, '\t')
		"echoerr "TAG===>".tag. "LEN===>".len(words)
		if len(words) < 5 
			continue
		endif
		"echon "------>". string(words)
		"echoerr "WORDS"
		let types=split(words[3],"|")
		"echoerr "===============000>". string(types). "Len====>".len(types)
		if len(types) < 3 
			continue
		endif
		let tg = copy(gTag)
		let tg.name=words[2]
		let tg.filename=words[0]
		if types[0] == "t" && (types[1] == "s" && types[2] == "d")
			let tname = substitute(types[3], '/', '_', 'g')
			let tname = types[3]
			let tg.name=tname
			let tg.kind='s'
			let tg.typeref="struct:".tname
		elseif types[0] == "t"
			let tg.name=types[2]
			let tg.kind="t"
			let tg.typeref="typedef:struct:".types[2]
		elseif types[0] == "s" 
			let tg.name=types[2]
			let tg.kind='s'
			let tg.typeref="struct:".types[2]
		elseif types[0] == "m" && (types[1] == "s" || types[1] == "t")
			let tg.name=types[2]
			let tg.kind='s'
			let tg.typeref="struct:".types[2]
		else
			let tg.kind=types[2]
		endif
		let tg.static="0"
		let tg.cmd=words[4]
		call add(gTagList, tg)
	endfor
	return gTagList
endfunc




" Same as TagList but don't throw exception
function! omni#common#utils#TagListNoThrow1(szTagQuery)
    let result = []
    try
        let result = omni#common#utils#TagList(a:szTagQuery)
    catch
    endtry
    return result
endfunc




" Same as TagList but don't throw exception
function! omni#common#utils#TagListNoThrow(szTagQuery)
    let taglist = []

	let result = omni#common#utils#GetGtag('dsx', a:szTagQuery)

	let taglist = omni#common#utils#GetGtagStruct(result)


	""call ECHO("GTAGS TAGLIST", taglist)
    return taglist
endfunc

" Get the word under the cursor
function! omni#common#utils#GetWordUnderCursor()
    let szLine = getline('.')
    let startPos = getpos('.')[2]-1
    let startPos = (startPos < 0)? 0 : startPos
    if szLine[startPos] =~ '\w'
        let startPos = searchpos('\<\w\+', 'cbn', line('.'))[1] - 1
    endif

    let startPos = (startPos < 0)? 0 : startPos
    let szResult = matchstr(szLine, '\w\+', startPos)
    return szResult
endfunc
