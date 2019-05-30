


function! DirTreeDiff (dir1, dir2, ...)
    autocmd FileChangedShell * echon ""

    let d1 = escape(a:dir1, '/')
    let d2 = escape(a:dir2, '/')
    let diffopts = " -x '*.o' -x '*.exe' -x '*.out' -x '*.xo' "
    if a:0 >0
        let diffopts .= a:1
    endif

            "echoerr "! diff -rqlpyN ". diffopts ." ". d1 ." ". d2 ." | sort >/tmp/diff.txt"


    silent execute "! diff -rqlp ". diffopts ." ". d1 ." ". d2 ." | sort >/tmp/diff.txt"
    silent execute "! vimdiff  "
                \. " <( echo ".d1.";cat /tmp/diff.txt | sed -e :a -e '/Only in ".d1."/{s/Only in ".d1."\\(.*\\): \\(.*\\)/\\1\\/\\2/g;n;ba}'  -e '/Files/{s
                \. " <( echo ".d2.";cat /tmp/diff.txt | sed -e :a -e '/Only in ".d2."/{s/Only in ".d2."\\(.*\\): \\(.*\\)/\\1\\/\\2/g;n;ba}'  -e '/Files/{s


        if v:version > 700
    redraw!
    q!
        endif
endfunc

function! DirTreeDiffView (dir1, dir2, ...)

    autocmd FileChangedShell * echon ""

    let d1 = a:dir1
    let d2 = a:dir2
    let diffopts = " -x '*.bin' "
    if a:0 >0
        let diffopts .= a:1
    endif



            "call ECHO("FILE:".a:1)
    call DirTreeDiff(d1, d2, diffopts)
        if v:version > 700
                redraw
                q
        endif
endfunc
command! -nargs=* DIFF call DirTreeDiff(<f-args>)

function! SelectDiffFile()
    if line(".") <= 1
        return
    endif
    let tag = GetStackTopTag()
    let dir1 = getline(1)
    let words1 = split(getline("."), '[ \t]')
    if len(words1) < 1
        return
    endif
    let file_name1 = substitute( words1[0], " ", "", "g")

    let dir2 = getbufline(bufname(2), 1, 1)[0]
    let line2 = getbufline(bufname(2), line("."), line("."))[0]
    let words2 = split(line2, '[ \t]')
    let file_name2 = substitute( words2[0], " ", "", "g")


            "echoerr "! vimdiff ".file_name1." ". file_name2
    autocmd FileChangedShell * echon ""
    silent execute "! vimdiff ".dir1."/".file_name1." ".dir2."/". file_name2
        if v:version > 700
    redraw!
        endif
endfunction



function! s:SetDiffOption ()
    silent noremap <buffer> <Enter> :call SelectDiffFile() <CR>
endfunc
au BufEnter * if &diff | call s:SetDiffOption() | endif



