

			"set autochdir
			"let dir=system("pwd")
			"let dir=substitute(dir, 'mucho.*', 'mucho/', "Ig")
			":cd "".dir
:set path=.
:set ts=8

exe "set tags=".findfile('atags', ".;").",atags"
exe "set tags+=". expand("%:p:h").'/tags,'. expand("%:p:h"). '/atags'
exe "set tags+=". './atags'

			" Tell vim to remember certain things when we exit
			"  '10  :  marks will be remembered for up to 10 previously edited files
			"  "100 :  will save up to 100 lines for each register
			"  :20  :  up to 20 lines of command-line history will be remembered
			"  %    :  saves and restores the buffer list
			"  n... :  where to save the viminfo files
:set viminfo='1000,\"10000,:200000,n~/.viminfo


function! RestoreCursor()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction
augroup restoreCursor
	autocmd!
	autocmd BufWinEnter * call RestoreCursor()
augroup END


			"Highlighting can be enabled on Vim startup
			":set viminfo^=h
			"autocmd BufReadPost *  if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g\`\"" |  endif

autocmd bufwritepost,filewritepost *.c  silent :call UpdateGtags() 
autocmd bufwritepost,filewritepost *.h  silent :call UpdateGtags() 
autocmd bufwritepost,filewritepost *.s  silent :call UpdateGtags() 
set ssop=blank,sesdir,folds,localoptions,tabpages,winpos,winsize


:set laststatus=2
:set scrolloff=2

:iab p(" printf("
:set nocompatible " explicitly get out of vi-compatible mode

if &cp
  finish
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

noremap <C-Y> <ESC>:call Header() <CR>
inoremap <C-Y> <ESC>:call Header() <CR>

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
:noremap   <F4> <ESC>:call Paste_Nopaste()<CR> i
:inoremap  <F4> <ESC>:call Paste_Nopaste()<CR> i


function! UpdateTags()

        if v:version > 700
		let dir=expand("%:p:h")
		:silent w!
		call system("cd ".dir.";ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f atags;")
        endif
endfun

			":noremap   <F3> <ESC>:call UpdateTags()<CR>
			":inoremap  <F3> <ESC>:call UpdateTags()<CR>






:syntax on
			":map <F10> :Tlist<CR><C-W><C-W>
			":map <F8> :! sudo chmod 777 % <CR> <CR> 
			":map <F3> :%s/\([\n ]*\)\(\n\){/\2{\2    M_TRACE(EV_TRACE_SEVERITY_DEBUG,":Entry");/gc
			":map <F4> :%s/\(.*return.*[\n ]*\)*\(\n\)}/\2    M_TRACE(EV_TRACE_SEVERITY_DEBUG,":Exit");\2&/gc
:map <C-K> :%s/<C-R>=expand("<cword>")<CR>/<C-R>=expand("<cword>")<CR>/gc
:map <C-J> :s/<C-R>=expand("<cword>")<CR>/<C-R>=expand("<cword>")<CR>/gc
:map <C-L> :'<,'>s/<C-R>=expand("<cword>")<CR>/<C-R>=expand("<cword>")<CR>/gc



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

			":map <C->> :tnext <CR> 
			":map <C-<> :tprevious <CR> 
:fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echo getline(search("^[^ \t#/]\\{2}", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun

:map U <ESC>:redo<CR>

			":map <ESC>q  <ESC>:q!<CR>
			" :set mouse=nv
:set shiftwidth=4
			":set expandtab
:set smartindent
:set incsearch
:set autoindent
			":colorscheme evening
:set tabstop=4
:set nowrap
":set ruler
"set rulerformat=%15(%c%V\ %p%%%)
:set backspace=2
:set hlsearch
:set cindent
			":set paste

:set ff=unix
:set hidden
:vnoremap <Tab> >gv
:vnoremap <S-Tab> <gv
			":set matchpairs


			"cmap wq!! %!sudo tee > /dev/null %       "Allow user to write files for non root users
:noremap XX <ESC>:q!<CR>
			":inoremap XX <ESC>:q!<CR>




			":set nocp
:filetype plugin on

			":set fo=cql
			":au FileType c,cpp,h setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
			":au FileType c,cpp,h setlocal comments-=://
			"
			""au FileType * setl fo-=cro

"TODO delay when i ESC
"inoremap <expr> k ((pumvisible())?("\<up>"):("k"))
"inoremap <expr> j ((pumvisible())?("\<down>"):("j"))
inoremap <expr> <C-k> ((pumvisible())?("\<up>"):("\<C-k>"))
inoremap <expr> <C-j> ((pumvisible())?("\<down>"):("\<C-j>"))

"set completeopt=menu,preview,longest
"set completeopt=menu
"set completeopt-=menu
set completeopt=menuone
set completeopt+=menu
set completeopt+=longest
:highlight PmenuSel ctermbg=2 guibg=2 guifg=2
			":highlight PmenuSel ctermbg=2 ctermfg=Magenta cterm=NONE guibg=Green guifg=Green gui=none


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
:noremap <C-U> :call Headers()<CR>


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
:noremap <C-A> :call ExpAlign()<CR>






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


let g:MatchGroup= [ 
		\{
		\	"MatchName":"Name1",
		\	"MatchColor":"cterm=bold  ctermbg=136 ctermfg=255",
		\	"MatchId":0
		\},
		\{
		\	"MatchName":"Name2",
		\	"MatchColor":"cterm=bold  ctermbg=94 ctermfg=255",
		\	"MatchId":0
		\},
		\{
		\	"MatchName":"Name3",
		\	"MatchColor":"cterm=bold  ctermbg=22 ctermfg=255",
		\	"MatchId":0
		\},
		\{
		\	"MatchName":"Name4",
		\	"MatchColor":"cterm=bold  ctermbg=52 ctermfg=255",
		\	"MatchId":0
		\},
		\{
		\	"MatchName":"Name5",
		\	"MatchColor":"cterm=bold  ctermbg=103 ctermfg=255",
		\	"MatchId":0
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
noremap ? :call Highlight_Match()<CR>


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
:noremap   q  <ESC> :call File_Header() <CR>
:inoremap  q  <ESC> :call File_Header() <CR>



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
:noremap  w  <ESC> :call Fun_Header() <CR>
:inoremap w  <ESC> :call Fun_Header() <CR>





			":noremap <ESC><ESC>  <ESC><C-w><C-w><ESC>

			"if has("cscope")
			"    set cscopetag
			"    set csto=0
			"    set cst
			"    set nocsverb
			"
			"    if filereadable("cscope.out")
			"        cs add cscope.out
			"    endif
			"    if filereadable("../cscope.out")
			"        cs add ../cscope.out
			"    endif
			"    if filereadable("../../cscope.out")
			"        cs add ../../cscope.out
			"    endif
			"    set csverb
			"
			"    :nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
			"    :nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
			"    :nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
			"    :nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
			"    :nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
			"    :nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
			"    :nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
			"    :nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	
			"
			"endif
			":noremap <F8> <ESC>:!cscope <CR>


			" Basics {
:set noexrc " don't use local version of .(g)vimrc, .exrc
			":set background=dark " we plan to use a dark background
:set cpoptions=aABceFsmq
			"             |||||||||
			"             ||||||||+-- When joining lines, leave the cursor 
			"             |||||||      between joined lines
			"             |||||||+-- When a new match is created (showmatch) 
			"             ||||||      pause for .5
			"             ||||||+-- Set buffer options when entering the 
			"             |||||      buffer
			"             |||||+-- :write command updates current file name
			"             ||||+-- Automatically add <CR> to the last line 
			"             |||      when using :@r
			"             |||+-- Searching continues at the end of the match 
			"             ||      at the cursor position
			"             ||+-- A backslash has no special meaning in mappings
			"             |+-- :write updates alternative file name
			"             +-- :read updates alternative file name
			" }


			" General {
filetype plugin indent on " load filetype plugins/indent settings
			"set autochdir " always switch to the current file directory 
:set backspace=indent,eol,start " make backspace a more flexible
			"set backup " make backup files
:set backupdir=~/.vim/backup " where to put backup files
:set clipboard+=unnamed " share windows clipboard
:set directory=~/.vim/tmp " directory to place swap files in
			":set fileformats=unix,dos,mac " support all three, in this order
:set hidden " you can change buffers without saving
:set iskeyword+=_,$,@,%,# " none of these are word dividers 
			"set "mouse=a " use mouse everywhere
set noerrorbells " don't make noise
			"set whichwrap=b,s,h,l,<,>,~,[,] " everything wraps
			"             | | | | | | | | |
			"             | | | | | | | | +-- "]" Insert and Replace
			"             | | | | | | | +-- "[" Insert and Replace
			"             | | | | | | +-- "~" Normal
			"             | | | | | +-- <Right> Normal and Visual
			"             | | | | +-- <Left> Normal and Visual
			"             | | | +-- "l" Normal and Visual (not recommended)
			"             | | +-- "h" Normal and Visual (not recommended)
			"             | +-- <Space> Normal and Visual
			"             +-- <BS> Normal and Visual
:set wildmenu " turn on command line completion wild style " ignore these list file extensions
:set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.jpg,*.gif,*.png
:set wildmode=list:longest " turn on wild mode huge list
			" }


    set backspace=indent,eol,start " make backspace a more flexible
    set backup " make backup files
    set clipboard+=unnamed " share windows clipboard
	set backupdir=~/.vim/backup " where to put backup files
	set directory=~/.vim/tmp " directory to place swap files in
    set fileformats=unix,dos,mac " support all three, in this order
    set hidden " you can change buffers without saving
			" (XXX: #VIM/tpope warns the line below could break things)
    set iskeyword+=_,$,@,%,# " none of these are word dividers
			"set mouse=a " use mouse everywhere

    set noerrorbells " don't make noise
			"set whichwrap=b,s,h,l,<,>,~,[,] " everything wraps
			"             | | | | | | | | |
			"             | | | | | | | | +-- "]" Insert and Replace
			"             | | | | | | | +-- "[" Insert and Replace
			"             | | | | | | +-- "~" Normal
			"             | | | | | +-- <Right> Normal and Visual
			"             | | | | +-- <Left> Normal and Visual
			"             | | | +-- "l" Normal and Visual (not recommended)
			"             | | +-- "h" Normal and Visual (not recommended)
			"             | +-- <Space> Normal and Visual
			"             +-- <BS> Normal and Visual
    set wildmenu " turn on command line completion wild style
    set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.jpg,*.gif,*.png " ignore these list file extensions
    set wildmode=list:longest " turn on wild mode huge list






	set linespace=0 " don't insert any extra pixel lines betweens rows
	set matchtime=1 " how many tenths of a second to blink matching brackets for
	"set nohlsearch " do not highlight searched for phrases
	set nostartofline " leave my cursor where it was
	set novisualbell " don't blink
			"set number " turn on line numbers
			"set numberwidth=5 " We are good up to 99999 lines
	set report=0 " tell us when anything is changed via :...
	"set ruler " Always show current positions along the bottom
	set scrolloff=2 " Keep 10 lines (top/bottom) for scope
			"set shortmess=aOstT " shortens messages to avoid 'press a key' prompt
	""set showcmd " show the command being typed
	set showmatch " show matching brackets
			"set sidescrolloff=10 " Keep 5 lines at the size

			" hit f11 to paste
			"set pastetoggle=<F4>
			" space / shift-space scroll in normal mode

"-------------------------------

			" Vim UI {
			"set cursorcolumn " highlight the current column
			"set cursorline " highlight current line
"":set incsearch " BUT do highlight as you type you " search phrase
"":set laststatus=2 " always show the status line
			":set lazyredraw " do not redraw while running macros
"":set linespace=0 " don't insert any extra pixel lines " betweens rows
			"set list " we do what to show tabs, to ensure we get them  out of my files
			"set listchars=tab:>-,trail:- " show tabs and trailing 
"":set matchtime=5 " how many tenths of a second to blink  matching brackets for
"":set hlsearch " do not highlight searched for phrases
"":set nostartofline " leave my cursor where it was
""set novisualbell " don't blink
			"set number " turn on line numbers
			"set numberwidth=5 " We are good up to 99999 lines
"":set report=0 " tell us when anything is changed via :...
"":set ruler " Always show current positions along the bottom
"":set scrolloff=2 " Keep 10 lines (top/bottom) for scope
"":set shortmess=aOstT " shortens messages to avoid 
			" 'press a key' prompt
			":set showcmd " show the command being typed
"":set showmatch " show matching brackets
"":set sidescrolloff=2 " Keep 5 lines at the size
			":set statusline=%f%=%m%r%h%w[%4l/%4L][%3p%%][%3v]
			"set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
			"              | | | | |  |   |      |  |     |    |
			"              | | | | |  |   |      |  |     |    + current 
			"              | | | | |  |   |      |  |     |       column
			"              | | | | |  |   |      |  |     +-- current line
			"              | | | | |  |   |      |  +-- current % into file
			"              | | | | |  |   |      +-- current syntax in 
			"              | | | | |  |   |          square brackets
			"              | | | | |  |   +-- current fileformat
			"              | | | | |  +-- number of lines
			"              | | | | +-- preview flag in square brackets
			"              | | | +-- help flag in square brackets
			"              | | +-- readonly flag in square brackets
			"              | +-- rodified flag in square brackets
			"              +-- full path to file in the buffer
			" }

			" Text Formatting/Layout {
			"set expandtab " no real tabs please!
""set history=9999 " big old history
			"set formatoptions=rq " Automatically insert comment leader on return, 
			" and let gq format comments
""set timeoutlen=300 " super low delay (works for me)
			"set formatoptions+=n " Recognize numbered lists
			"set formatlistpat=^\\s*\\(\\d\\\|[-*]\\)\\+[\\]:.)}\\t\ ]\\s* "and bullets, too

			" set ignorecase " case insensitive by default
			" set infercase " case inferred by default
 set nowrap " do not wrap line
			"set shiftround " when at 3 spaces, and I hit > ... go to 4, not 5
			" set smartcase " if there are caps, go case-sensitive
 set shiftwidth=4 " auto-indent amount when using cindent, " >>, << and stuff like that
 set softtabstop=4 " when hitting tab or backspace, how many spaces "should a tab be (see expandtab)
 set tabstop=4 " real tabs should be 8, and they will show with " set list on
			" }
			"ignore white space in vimdiff 
set diffopt+=iwhite


":noremap ?  <ESC>:let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
:noremap < <ESC><C-D>
:noremap > <ESC><C-U>

:inoremap , <ESC><C-D>
:inoremap . <ESC><C-U>
:noremap , <ESC><C-D>
:noremap . <ESC><C-U>

:noremap e <ESC>A
:noremap b <ESC>I
:inoremap e <ESC>A
:inoremap b <ESC>I

:noremap f <C-]>
			":noremap n <C-]>
:noremap t <C-T>
:noremap r <C-T>
:inoremap f <C-]>
			":inoremap n <C-]>
:inoremap r <C-T>
:inoremap t <C-T>

			":inoremap h <ESC>i
			":inoremap l <ESC>lli
			":noremap h <ESC>h
			":noremap l <ESC>l

"TODO delay in tomeout
":inoremap j <ESC>ji
":inoremap k <ESC>ki
":noremap j <ESC>j
":noremap k <ESC>k


:noremap [B <ESC>j
:noremap [A <ESC>k

:inoremap [B <ESC>j
:inoremap [A <ESC>k


function! IMoveUp()
	call cursor( line('.')-1, 0)
endfunction

function! IMoveDown()
	call cursor( line('.')+1, 0)
endfunction

			":inoremap k  <ESC>:call IMoveUp()<CR>i
			":inoremap j  <ESC>:call IMoveDown()<CR>i
			"silent inoremap h <C-O>h
			"silent inoremap j <C-O>j
			"silent inoremap k <C-O>k
			"silent inoremap l <C-O>l

			"Command mode map
cmap <C-F> <C-R><C-W>
cmap <C-S> <C-R><C-W>

:set noeb vb t_vb=

:fun! OpenFile()
    set path=.,/usr/include/,/usr/local/include/,./**,../**,../../**
    execute "normal! gf"
    set path=.
endfun
			":noremap gf :call OpenFile()<CR>

:noremap  <F12> <ESC>:'<,'>!column -t<CR>
:noremap! <F12> <ESC>:'<,'>!column -t<CR>


:fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echo getline(search("^[^ \t#/]\\{2}", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun


:set encoding=utf-8 
:set fileencodings=ucs-bom,utf-8



			"#ifdef 
			":noremap  2 <ESC>i#ifdef 
			":inoremap 2 <ESC>i#ifdef 
			":noremap  3 <ESC>i#else
			":inoremap 3 <ESC>i#else
			":noremap  4 <ESC>i#endif 
			": 4 <ESC>i#endif 

			"Alt-Backspace = Delete a world
:noremap  <BS> i<C-W>
:inoremap <BS> i<C-W>
:noremap   db
:noremap   db
:inoremap   <C-W>


" CTL + h
":inoremap   <C-W>
":noremap   <C-W>
":inoremap   <C-W>



			"Alt + arrow = Foward/Backword word
:noremap  f <esc>wi
:inoremap f <esc>lwi
:noremap  r <ESC>bi
:inoremap r <ESC>bi

			"Alt + arrow = Foward/Backword word
:noremap  OC <esc>w
:inoremap OC <esc>w
:noremap  OD <esc>b
:inoremap OD <esc>b


			"Alt + arrow = Up/Down
":noremap  OA <esc>-20<CR>
":inoremap OA <esc>-20<CR>
":noremap  OB <esc>+20<CR>
":inoremap OB <esc>+20<CR>




			" Alt + '+'
:noremap  = <ESC>:set wrap <CR>
:inoremap = <ESC>:set wrap <CR>
:noremap  + <ESC>:set nowrap <CR>
:inoremap + <ESC>:set nowrap <CR>



			" Color scheme
			"":set t_AB=[48;5;%dm
			":set t_AF=[38;5;%dm
:set t_Co=256
let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
:colorscheme  kalimuthu
			" restore screen after quitting
    if has("terminfo")
        let &t_Sf="\ESC[3%p1%dm"
        let &t_Sb="\ESC[4%p1%dm"
    else
        let &t_Sf="\ESC[3%dm"
        let &t_Sb="\ESC[4%dm"
    endif
			" Odds n Ends
			"set ttymouse=xterm2 " makes it work in everything




let g:ctags_path='/usr/bin/ctags'
let g:ctags_args='-I __declspec+'
			""   (or whatever other additional arguments you want to pass to ctags)
			"let g:ctags_statusline=2    " To show tag name in status line.
let generate_tags=1 " To start automatically when a supported  file is opened.



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

			":noremap  o <ESC>:call Printf() <CR>i
			":inoremap o <ESC>:call Printf() <CR>i



			" Cursor goes beyond last character
 set virtualedit=onemore,block
hi folded guifg=red "wrap the cursor

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



:map  <F1>   <ESC>:q <CR>
:imap <F1>   <ESC>:q <CR>

:noremap   <F2>  <ESC>:silent write <CR> 
:inoremap  <F2>  <ESC>:silent write <CR>
:noremap   <F3> <ESC>:call UpdateGtags()<CR>
:inoremap  <F3> <ESC>:call UpdateGtags()<CR>


:noremap <F5> :!cleartool co -nc <C-R>=expand("%p") <CR> <CR>
:noremap <F6> :!cleartool ci -nc <C-R>=expand("%p") <CR> <CR>
:noremap <F7> :!cleartool update -f -over  <C-R>=expand("%p") <CR> <CR>
:noremap <F8> :!cleartool unco -keep <C-R>=expand("%p") <CR><CR>


function! FormatFile()
        if v:version > 700
		:%s/.*"\(.*\)".*/\1/gc
		:%s/@@.*//gc
		:%s/\\/\//gc 
		:%s/\/\//\//gc
		:%s/.*mucho.//gc
        endif
endfunction




			"BROCADE 

			":noremap   <F9> <ESC>o#if !defined (MLX4x40G_BRINGUP)<ESC>i
			":inoremap  <F9> <ESC>o#if !defined (MLX4x40G_BRINGUP)<ESC>i
:noremap  <F10> <ESC>o#else<ESC>li
:inoremap <F10> <ESC>o#else<ESC>li
:noremap  <F11> <ESC>o#endif<ESC>li
:inoremap <F11> <ESC>o#endif<ESC>li





			"KALS
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

			"let g:diffopts=""
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
				\. " <( echo ".d1.";cat /tmp/diff.txt | sed -e :a -e '/Only in ".d1."/{s/Only in ".d1."\\(.*\\): \\(.*\\)/\\1\\/\\2/g;n;ba}'  -e '/Files/{s/Files ".d1."\\(.*\\) and.*/\\1/g;n;ba;}' -e 's/Only in ".d2."\\(.*\\).*: /\\/\\1\\/\\//g;'  )" 
				\. " <( echo ".d2.";cat /tmp/diff.txt | sed -e :a -e '/Only in ".d2."/{s/Only in ".d2."\\(.*\\): \\(.*\\)/\\1\\/\\2/g;n;ba}'  -e '/Files/{s/Files ".d1."\\(.*\\) and ".d2."\\(.*\\) differ/\\2/g;n;ba;}' -e 's/.*".d1."\\(.*\\): \\(.*\\)/\\/\\1\\/\\2/g;'  )"


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


let g:search_pattern=""
function! LineSearch()
	call search("\\%".line('.')."l".g:search_pattern)
endfunction
function! LineSearchInput()
	let g:search_pattern = input("_/")
	call LineSearch()
endfunction
noremap \		:call LineSearchInput() <CR>
inoremap \	<ESC>:call LineSearchInput() <CR>
inoremap ./	<ESC>:call LineSearchInput() <CR>
noremap ./	:call LineSearchInput() <CR>

inoremap n	<ESC>:call LineSearch() <CR>
noremap n		:call LineSearch() <CR>

let tagmenuLoaded=1
let g:menuname = "]Tags"


inoremap  q  <C-R>=ListMonths()<CR> 



set dictionary=~/.vim/dictionary
set complete+=k

if &term =~ "xterm"
	let &t_SI = "\<Esc>]12;purple\x7"
	let &t_EI = "\<Esc>]12;blue\x7"
endif

			":autocmd InsertEnter,InsertLeave * set cul
			"let &t_SI="\<Esc>]50;CursorShape=1\x7"
			"let &t_EI="\<Esc>]50;CursorShape=2\x7"
			"
if v:version > 700
        autocmd InsertEnter * set nocul | set mouse=c
        autocmd InsertLeave * set cul   | set mouse=i
		autocmd VimEnter * set cul
		":set timeoutlen=200
		set timeoutlen=300 ttimeoutlen=10
endif


set noerrorbells visualbell t_vb=
if has('autocmd')
	autocmd GUIEnter * set visualbell t_vb=
endif
set visualbell
set noerrorbells

			"set cursorline
			"set cursorcolumn


if v:version > 700
        hi normal   ctermbg=16
        hi cursor ctermbg=15 ctermfg=8
endif

			"RED
			"hi cursorline   cterm=underline  ctermbg=0 ctermfg=none
			"hi statusline   cterm=bold       ctermbg=52  ctermfg=255


			"GREEN
			"hi cursorline   cterm=underline,bold  ctermbg=0  ctermfg=none
			"hi statusline   cterm=bold       ctermbg=22  ctermfg=255

			"BLUE
			"hi cursorline  cterm=underline    ctermbg=0   ctermfg=none
			"hi statusline  cterm=bold         ctermbg=17  ctermfg=255

			"bold
			"underline
			"undercurl       not always available
			"reverse
			"inverse         same as reverse
			"italic
			"standout
			"NONE            no attributes used (used to reset it)


			"GRAY
			"hi cursorline   cterm=bold  ctermbg=8  ctermfg=none
			"hi statusline   cterm=bold  ctermbg=7  ctermfg=16

			"GRAY

if v:version > 700
        hi cursorline   cterm=bold  ctermfg=none ctermbg=239
endif
			"hi statusline   cterm=none  ctermfg=white ctermbg=24

			"cursor down/up existing lines
			"imap <S-Down> _<Esc>mz:set ve=all<CR>i<Down>_<Esc>my`zi<Del><Esc>:set
			"ve=<CR>`yi<Del>
			"imap <S-Up> _<Esc>mz:set ve=all<CR>i<Up>_<Esc>my`zi<Del><Esc>:set
			"ve=<CR>`yi<Del>
			""cursor down with a new line
			"imap <S-CR> _<Esc>mz:set ve=all<CR>o<C-o>`z<Down>_<Esc>my`zi<Del><Esc>:set ve=<CR>`yi<Del>

let g:autoclose_on = 0
set encoding=utf-8
scriptencoding utf-8


function! GetMode()
	let mode=mode()
	if mode == 'i'
			"hi ModeColor ctermfg=255 ctermbg=52
		return "INSERT"
	elseif mode == 'V'
			"hi ModeColor ctermfg=255 ctermbg=31
		return "VISUAL"
	elseif mode == 'R'
			"hi ModeColor ctermfg=255 ctermbg=52 
		return "REPLACE"
	else
			"hi ModeColor ctermfg=255 ctermbg=22
		return "NORMAL"
	endif
endfunction

function! GetSyntaxItem()
	return "   ".synIDattr(synID(line("."),col("."),1),"name")."   "
endfunction

function! GetFTagName()
	return "  ". GetTagName(line("."))."()  "
endfunction


function! GetFileMode()
			"return " ".getfperm(expand('%:p'))." | ". ( &modified ?"[ + ] ":"  -   " )." | ".(&paste?" PASTE ":"  ---  ")." | ".(&spell?&spelllang:"no spell")." "

	return " ".(&modified==1?" [ + ] ":' [ - ] '). (&paste?"| PASTE ":"|  ---  ")
endfunction


let g:dec_type=" "
function! UpdateDeclaration()
			" Save the last search
	let last_search=@/
			" Save the current cursor position
	let save_cursor = getpos(".")
			" Save the window position
			"normal H
	let save_window = getpos(".")
	call setpos('.', save_cursor)

	let save_cursor = getpos(".")
	try
		let declaration = " "
		if searchdecl(expand("<cword>"), 1, 1) == 0
			let declaration = getline(".")
			let declaration=substitute(declaration, '[\t *()]*\<'.expand("<cword>").'\>.*', '', "Ig")
			let declaration=substitute(declaration, '.*[\t(, ]', '', "Ig")
			"call setpos('.', save_cursor)
			let g:dec_type=declaration
		endif
	catch
	endtry
			" Restore the last_search
	let @/=last_search
			" Restore the window position
	call setpos('.', save_window)
			"normal zt
			" Restore the cursor position
	call setpos('.', save_cursor)

endfunction


function! GetVariableDec()
    return "  ". g:dec_type. " |"
endfunction

function! GetLeftSep()
    return "►" "25ba
endfunction
function! GetRightSep()
    return "☷" "25ba
	"return "◄" "25c4
endfunction

    "return "☷" "25ba
	"return "≪" "f011
    "return "≫" "25ba
	"return "▐" "2590
    "return "│" "25ba
    "return "▌" "25ba
    "return "◆"  "25c6
    "return "❖" "2756
    "return "⠗"
    "return "►" "25ba
	"return "◄" "25c4
    "return "ᐅ"
    "return "▼"  "25bc
    "return "▲" "25b2




hi ModeColor ctermfg=255 ctermbg=22
hi ModeSepColor ctermfg=22 ctermbg=94

hi FileColor ctermfg=255 ctermbg=94
hi FileSepColor ctermfg=94 ctermbg=24

hi FileModeColor ctermfg=255 ctermbg=24
hi FileModeSepColor ctermfg=24 ctermbg=145

hi VariableDecColor ctermfg=255 ctermbg=23
hi SyntaxColor ctermfg=255 ctermbg=145

hi FuncNameSepColor ctermfg=0 ctermbg=243
hi FuncNameColor ctermfg=255 ctermbg=95
hi AttrColor ctermfg=255 ctermbg=23 

hi RowColSepColor ctermfg=0 ctermbg=23
hi RowColColor ctermfg=231 ctermbg=94

hi LocSepColor ctermfg=0 ctermbg=94
hi LocColor ctermfg=255 ctermbg=52 

hi EndSepColor ctermfg=0 ctermbg=52 

if has('statusline')
  set statusline=%#ModeColor#                  " set highlighting
  set statusline+=\ %-8{GetMode()}            " set highlighting
  set statusline+=%#ModeSepColor#%{GetLeftSep()}
  set statusline+=%#FileColor#                 " set highlighting
  set statusline+=\ %-f\                          " file name
  set statusline+=%#FileSepColor#%{GetLeftSep()}
  set statusline+=%#FileModeColor#              " syntax highlight group under cursor
  set statusline+=%{GetFileMode()}                " file format
  set statusline+=%#FileModeSepColor#%{GetLeftSep()}
  set statusline+=%#SyntaxColor#              " syntax highlight group under cursor
  set statusline+=%=                           " ident to the right
  set statusline+=%#FuncNameSepColor#%{GetRightSep()}
  set statusline+=%#VariableDecColor#              " syntax highlight group under cursor
  set statusline+=%10.40{GetVariableDec()}                " file format
  set statusline+=%10.50{GetFTagName()}              " syntax highlight group under cursor
  set statusline+=%#RowColSepColor#%{GetRightSep()}
  set statusline+=%#RowColColor#\ %5l\ \:\ %-3v\          " cursor position/offset
  set statusline+=%#LocSepColor#%{GetRightSep()}
  set statusline+=%#LocColor#\ %(\ %L\ \/\ %-3p%%\ %)\               " file format
  set statusline+=%#EndSepColor#%{GetRightSep()}
endif




if !&diff
	setl autoread
endif

			"au CursorHold * checktime 
if !&diff 
	au FocusGained,BufEnter,BufWinEnter,CursorHold,CursorMoved * :checktime
	au FocusGained,BufEnter,BufWinEnter,CursorHold *.[ch] :call UpdateDeclaration()
endif


			"Hightlight current char
			"match ErrorMsg '\%#'


let g:agprg=$HOME."/utils/bin/ag --column"

"DIFF options
noremap do do]c
noremap dp dp]c




:noremap  wq <ESC>:wq<CR>

"set swap(.swp),backup(.bak),undo(.udf)



let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"


"Keep the cursor on same colum when ESC is presed
"inoremap <silent> <ESC> <C-O>:stopinsert<CR>

"sets coluum and row
"set lines=999 columns=999
"exec "set lines=".winheight(0)." columns=".winwidth(0)


			"noremap <Space> <PageDown>
			"noremap  <PageUp>



			"TODO:
			"Header memnu
			"search within line
			"Popup menu
			"Ctags function, syntax status
			"pigment parser
			"register copy/paste
			"multiple search hightlight
			"v file:22 separate linumber
			"Header file search optimxation autocomplete
			"Function prototype autocomplete
			"Auto complete dont seletect first item
			"shortcut keys in .vimrc for all 
			"Help document for all
