


function! FindGtagsPath()
    let path = getcwd()
    let file = findfile("GTAGS", ".;")
    if file[0] != '/'
        let path = getcwd().'/'
    else
        let path = substitute(file, '[^/]*[/]*$', '', "g")
    endif
    return path
endfunction



function! UpdateGtags()
    let path = FindGtagsPath()
    let file = substitute(expand("%:p"), path, "", "g")

    let cmd = "~/utils/tools/gupdate \"".path."\" \"gtags --single-update ". file ."\" &"
            "echoerr cmd
    :silent call system(cmd)
endfunction


if !exists('cmd_update_gtags_file')
    let cmd_update_gtags_file = '<leader><C-L>'
endif
exec ":noremap  ". g:cmd_update_gtags_file ." <ESC>:call UpdateGtags()<CR>"
exec ":inoremap ". g:cmd_update_gtags_file ." <ESC>:call UpdateGtags()<CR>"
