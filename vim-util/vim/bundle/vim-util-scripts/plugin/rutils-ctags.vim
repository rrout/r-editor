


function! UpdateTags()

        if v:version > 700
        let dir=expand("%:p:h")
        :silent w!
        call system("cd ".dir.";ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f atags;")
        endif
endfun
":noremap   <F3> <ESC>:call UpdateTags()<CR>
":inoremap  <F3> <ESC>:call UpdateTags()<CR>


