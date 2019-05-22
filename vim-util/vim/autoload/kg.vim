" NOTE: You must, of course, install kg / the_silver_searcher

" FIXME: Delete deprecated options below on or after 15-7 (6 months from when they were changed) {{{

if exists("g:kgprg")
  let g:kg_prg = g:kgprg
endif

if exists("g:kghighlight")
  let g:kg_highlight = g:kghighlight
endif

if exists("g:kgformat")
  let g:kg_format = g:kgformat
endif

" }}} FIXME: Delete the deprecated options above on or after 15-7 (6 months from when they were changed)

" Location of the kg utility
if !exists("g:kg_prg")
  " --vimgrep (consistent output we can parse) is available from version  0.25.0+
  if split(system("kg --version"), "[ \n\r\t]")[2] =~ '\d\+.[2-9][5-9]\(.\d\+\)\?'
    let g:kg_prg="kg --vimgrep"
  else
    " --noheading seems odd here, but see https://github.com/ggreer/the_silver_searcher/issues/361
    let g:kg_prg="kg --column --nogroup --noheading"
  endif
endif

if !exists("g:kg_apply_qmappings")
  let g:kg_apply_qmappings=1
endif

if !exists("g:kg_apply_lmappings")
  let g:kg_apply_lmappings=1
endif

if !exists("g:kg_qhandler")
  let g:kg_qhandler="botright copen"
endif

if !exists("g:kg_lhandler")
  let g:kg_lhandler="botright lopen"
endif

if !exists("g:kg_mapping_messkge")
  let g:kg_mapping_message=1
endif

function! kg#KgBuffer(cmd, args)
  let l:bufs = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let l:files = []
  for buf in l:bufs
    let l:file = fnamemodify(bufname(buf), ':p')
    if !isdirectory(l:file)
      call add(l:files, l:file)
    endif
  endfor
  call kg#Kg(a:cmd, a:args . ' ' . join(l:files, ' '))
endfunction

function! kg#GtagsKg(cmd, args)
	call kg#Kg(a:cmd . " --gtagsgrep ", a:args)
endfunc

function! kg#Kg(cmd, args)
    let l:results = ''
  let l:kg_executable = get(split(g:kg_prg, " "), 0)
  let l:srch = '"'.a:args.'"'

  " Ensure that `kg` is installed
  if !executable(l:kg_executable)
    echoe "Kg command '" . l:kg_executable . "' was not found. Is the silver searcher installed and on your $PATH?"
    "return
  endif

  " If no pattern is provided, search for the word under the cursor
  if empty(a:args)
    let l:grepargs = expand("<cword>")
  else
    let l:grepargs = l:srch . join(a:000, ' ')
  end

  " Format, used to manage column jump
  if a:cmd =~# '-g$'
    let s:kg_format_backup=g:kg_format
    let g:kg_format="%f"
  elseif exists("s:kg_format_backup")
    let g:kg_format=s:kg_format_backup
  elseif !exists("g:kg_format")
    let g:kg_format="%f:%l:%c:%m"
  endif

	"echoerr l:kg_executable."-".a:cmd
  let l:grepprg_bak=&grepprg
  let l:grepformat_bak=&grepformat
  let l:t_ti_bak=&t_ti
  let l:t_te_bak=&t_te
  try
    let &grepprg=g:kg_prg
    let &grepformat=g:kg_format
    set t_ti=
    set t_te=
	"echoerr a:cmd . " " . escape(l:grepargs, '|')
    let l:results=system(a:cmd . " " . escape(l:grepargs, '|'))
  finally
    let &grepprg=l:grepprg_bak
    let &grepformat=l:grepformat_bak
    let &t_ti=l:t_ti_bak
    let &t_te=l:t_te_bak
  endtry

	"echoerr l:results
  if l:results != ''
    call OpenTag("SEARCH", a:args, l:results )
  else
    echom 'No matches for "'.a:args.'"'
  endif
endfunction

function! kg#KgFromSearch(cmd, args)
  let search =  getreg('/')
  " translate vim regular expression to perl regular expression.
  let search = substitute(search,'\(\\<\|\\>\)','\\b','g')
  call kg#Kg(a:cmd, '"' .  search .'" '. a:args)
endfunction

function! kg#GetDocLocations()
  let dp = ''
  for p in split(&runtimepath,',')
    let p = p.'/doc/'
    if isdirectory(p)
      let dp = p.'*.txt '.dp
    endif
  endfor
  return dp
endfunction

function! kg#KgHelp(cmd,args)
  let args = a:args.' '.kg#GetDocLocations()
  call kg#Kg(a:cmd,args)
endfunction
