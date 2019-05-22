" File : PopupBuffer.vim
" Last Change: 2001 Nov 13
" Maintainer: Gontran BAERTS <gbcreation@free.fr>
" Version : 1.1.1
"
" Please don't hesitate to correct my english :)
" Send corrections to gbcreation@free.fr
"
"-----------------------------------------------------------------------------
" Vim global plugin for selecting buffer from PopUp menu
"
"-----------------------------------------------------------------------------
" Normally, this file will reside in your plugins directory and be
" automatically sourced.  If not, you must manually source this file
" using :source PopupBuffer.vim
"
"-----------------------------------------------------------------------------
" Updates in version 1.1.1
" - Fix stupid bug in PBAdd() function. Directories were added to popup buffers
"   menu and never removed.
" Updates in version 1.1
" - Allow to control the menu item format with popupBufferPattern global
"   variable. Use %F for full file path, %f for file name, %p for file path,
"   and %n for buffer number.
"   For example:
"   let g:popupBufferPattern = "Select %f (%n) from %p directory"
" - Fix unremoved deleted buffers from menu
" - Improve addition of new item to menu. Don't add all buffers each time.
"
" Updates in version 1.0
" - First version

"KALS
let loaded_bufferpopup = 1

" Has this already been loaded ?
if exists("loaded_bufferpopup")
  finish
endif
let loaded_bufferpopup = 1

let s:pbmenu_wait = 1

if !exists("g:popupBufferPattern")
  let g:popupBufferPattern="%f (%n)\t%p"
endif

" Add new buffer to popup menu
function! <SID>PBAdd( fname, bnum )
	if !isdirectory(a:fname)
		exe "amenu PopUp.Buffers." . <SID>PBFormat( a:fname, a:bnum ) . " :b " . a:bnum . "<CR>"
	endif
endfunc

" Remove deleted buffer from popup menu
func! <SID>PBRemove()
	let name = expand("<afile>")
	if !isdirectory(name)
		exe "aunmenu PopUp.Buffers." . <SID>PBFormat(  name, expand("<abuf>") )
	endif
endfunc

" Format menu entry
func! <SID>PBFormat(fname, bnum)
	let name = a:fname
	if name == ''
		let name = "[No File]"
	else
		let name = fnamemodify(name, ':p:~')
	endif

	" Parse popupBufferPattern
	let item = substitute( g:popupBufferPattern, "%F", name, "g" )
	let item = substitute( item, "%f", fnamemodify(name, ':t'), "g" )
	let item = substitute( item, "%p", fnamemodify(name, ':h'), "g" )
	let item = substitute( item, "%n", a:bnum, "g" )

	" Some cleaning
	let item = escape( item, "\\. \t|")
	let item = substitute( item, "\n", "^@", "g")
	return item
endfunc

function! <SID>PBShow()
	" Add current buffers
	let buf = 1
	while buf <= bufnr('$')
		if bufexists(buf) && !getbufvar(buf, "&bufsecret")
			call <SID>PBAdd( bufname(buf), buf )
		endif
		let buf = buf + 1
	endwhile

	" Define autocommands
	augroup buffer_popup
	au!
	au BufCreate,BufFilePost * call <SID>PBAdd( expand("<afile>"), expand("<abuf>") )
	au BufDelete,BufFilePre * call <SID>PBRemove()
	augroup END
endfunction

" Initialization
"noremap  d  <C-R>:call <SID>PBShow() <CR>
"inoremap d  <C-R>:call <SID>PBShow() <CR>


function! PBInit()
	call omni#cpp#settings#Init()
    set omnifunc=LoadBuffers
    inoremap <expr><C-X><C-O> omni#cpp#maycomplete#Complete()
    noremap <expr>d    ShowBuffers()
    inoremap <expr>d    ShowBuffers()
	call <SID>PBShow()
endfunc
"call PBInit()


function! s:CanUsePopOmnicompletion()
    " For C and C++ files and only if the omnifunc is omni#cpp#complete#Main
    return (&omnifunc == 'LoadBuffers' )
endfunc

" This function is used for the 'omnifunc' option.
function! LoadBuffers(findstart, base)
	"call ECHO("main:", "findstart=>", a:findstart, "base=>", a:base)
	let buf=[{'cmd': ' int a;', 'word': 'a', 'static': '1', 'name': 'A::a', 'dup': 0, 'menu': '+ d', 'info': '', 'kind': 'm', 'abbr': 'a', 'struct': 'd', 'access': 'public', 'filename': 'bit_trick.c'}, {'cmd': ' int b;', 'word': 'b', 's tatic': '1', 'name': 'A::b', 'dup': 0, 'menu': '+ d', 'info': '', 'kind': 'm', 'abbr': 'b', 'struct': 'd', 'access': 'public', 'filename': 'bit_trick.c'}]

    if a:findstart
		return col('.')
	else
		return buf
	endif
endfunc



function! ShowBuffers()
	"echoerr "SHOW".s:CanUsePopOmnicompletion(). omni#cpp#maycomplete#Complete()
    if s:CanUsePopOmnicompletion()
		return  omni#cpp#maycomplete#Complete()
	endif
endfunc












"---------------------------------------------------------------------------
" forms#tutorial#editor_slider#Make()
" Create a SelectList and Deck and wire them together
" using an Action so that the SelectList controls which of the Deck's
" Cards is showing.
"
" parameters: None
"---------------------------------------------------------------------------
function! Make()
	let t1 = forms#newText({'textlines': "CardOne"})
	let t2 = forms#newText({'textlines': "CardTwo"})
	let t3 = forms#newText({'textlines': "CardThree"})
	let t4 = forms#newText({'textlines': "CardFour"})
	let deck = forms#newDeck({'children': [t1, t2, t3, t4]})
	function! V4Action(...) dict
		let pos = a:1
		call self.deck.setCard(pos)
	endfunction
	let action = forms#newAction({ 'execute': function("V4Action")})
	let action['deck'] = deck
	let attrs = { 'mode': 'single',
				\ 'pos': 0,
				\ 'choices': [
				\ ["one", 1],
				\ ["two", 2],
				\ ["three", 3],
				\ ["four", 4]
				\ ], 'size': 4,
				\ 'on_selection_action': action
				\ }
	let slist = forms#newSelectList(attrs)
	function! slist.purpose() dict
		return "Select item to change Deck top-of-card."
	endfunction
	let b = forms#newBorder({'body': slist, 'char': ' '})
	let hpoly = forms#newHPoly({'children': [b, deck],
				\ 'alignment': 'C' })
	let bg = forms#newBackground({ 'body': hpoly})
	let form = forms#newForm({'body': bg })
	function! form.purpose() dict
		return "This is Help associated with the SelectList/Deck Tutorial Form."
	endfunction
	call form.run()
endfunction

