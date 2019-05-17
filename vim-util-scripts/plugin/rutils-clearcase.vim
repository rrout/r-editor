


if !exists('cmd_clearcase_check_out')
    let cmd_clearcase_check_outd = '<leader><F5>'
endif
if !exists('cmd_clearcase_check_in')
    let cmd_clearcase_check_int = '<leader><F5>'
endif
if !exists('cmd_clearcase_update')
    let ccmd_clearcase_update = '<leader><F7>'
endif
if !exists('cmd_clearcase_undo_check_out')
    let cmd_clearcase_undo_check_out = '<leader><F8>'
endif

exec ":noremap ". g:cmd_clearcase_check_out ." :!cleartool co -nc -version <C-R>=resolve(expand(\"%:p\")) <CR> <CR>"
exec ":noremap ". g:cmd_clearcase_check_in ." :!cleartool ci -nc <C-R>=resolve(expand(\"%p\")) <CR> <CR>"
exec ":noremap ". g:cmd_clearcase_update ." :!cleartool update -f -over  <C-R>=resolve(expand(\"%p\")) <CR> <CR>"
exec ":noremap ". g:cmd_clearcase_undo_check_out ." :!cleartool unco -keep <C-R>=resolve(expand(\"%p\")) <CR><CR>"
