" Color test: Save this file, then enter ':so %'
" Then enter one of following commands:
"   :VimColorTest    "(for console/terminal Vim)
"   :GvimColorTest   "(for GUI gvim)
function! VimColorTest(outfile, fgend, bgend)
  let result = []
  for fg in range(0, a:fgend, 1)
		  for bg in range(0, a:bgend, 1)
      let kw = printf('%-7s', printf('color_test_sample_%d_%d', fg, bg))
      let h = printf('hi %s ctermfg=%d ctermbg=%d', kw, fg, bg)
      let s = printf('syn keyword %s %s', kw, kw)
      call add(result, printf('%-32s | %s', h, s))
	  call add(result, "\n")
    endfor
  endfor
  call writefile(result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction
" Increase numbers in next line to see more colors.
command! VimColorTest call VimColorTest('vim-color-test.tmp', 16, 255)

function! GvimColorTest(outfile)
  let result = []
  for red in range(0, 255, 16)
    for green in range(0, 255, 16)
      for blue in range(0, 255, 16)
        let kw = printf('%-13s', printf('color_test_%d_%d_%d', red, green, blue))
        let fg = printf('#%02x%02x%02x', red, green, blue)
        let bg = '#fafafa'
        let h = printf('hi %s guifg=%s guibg=%s', kw, fg, bg)
        let s = printf('syn keyword %s %s', kw, kw)
        call add(result, printf('%s | %s', h, s))
      endfor
    endfor
  endfor
  call writefile(result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction
command! GvimColorTest call GvimColorTest('gvim-color-test.tmp')

" Color test: Save this file, then enter ':so %'
" Then enter one of following commands:
"   :VimColorTest    "(for console/terminal Vim)
"   :GvimColorTest   "(for GUI gvim)
function! VimColorTestRange(outfile, fgend, bgend)
	let result = []
	for fg in range(a:fgend)
		for bg in range(a:bgend)
			let kw = printf('%-7s', printf('c_%d_%d', fg, bg))
			let h = printf('hi %s ctermfg=%d ctermbg=%d', kw, fg, bg)
			let s = printf('syn keyword %s %s', kw, kw)
			call add(result, printf('%-32s | %s', h, s))
		endfor
	endfor
	call writefile(result, a:outfile)
	execute 'edit '.a:outfile
	source %
endfunction
" Increase numbers in next line to see more colors.
command! VimColorTestRange call VimColorTestRange('vim-color-test.tmp', 12, 16)

function! GvimColorTestRange(outfile)
	let result = []
	for red in range(0, 255, 16)
		for green in range(0, 255, 16)
			for blue in range(0, 255, 16)
				let kw = printf('%-13s', printf('c_%d_%d_%d', red, green, blue))
				let fg = printf('#%02x%02x%02x', red, green, blue)
				let bg = '#fafafa'
				let h = printf('hi %s guifg=%s guibg=%s', kw, fg, bg)
				let s = printf('syn keyword %s %s', kw, kw)
				call add(result, printf('%s | %s', h, s))
			endfor
		endfor
	endfor
	call writefile(result, a:outfile)
	execute 'edit '.a:outfile
	source %
endfunction
command! GvimColorTest call GvimColorTest('gvim-color-test.tmp')






function! VimFontColorTest(outfile, fgend, bgend)
	hi Normal  ctermbg=231	
	let result = []
	for fg in range(0, a:fgend, 1)
		"for bg in range(0, a:bgend, 1)
		let bg=231
		let ct='none'
		let kw = printf('%-7s', printf('color_test_sample_%d_%d_%s', fg, bg, ct))
		let h = printf('hi %s ctermfg=%d ctermbg=%d cterm=%s', kw, fg, bg, ct)
		let s = printf('syn keyword %s %s', kw, kw)
		call add(result, printf('%-32s | %s', h, s))
		call add(result, "\n")


		let ct='bold'
		let kw = printf('%-7s', printf('color_test_sample_%d_%d_%s', fg, bg, ct))
		let h = printf('hi %s ctermfg=%d ctermbg=%d cterm=%s', kw, fg, bg, ct)
		let s = printf('syn keyword %s %s', kw, kw)
		call add(result, printf('%-32s | %s', h, s))
		call add(result, "\n")
		"endfor
	endfor
	call writefile(result, a:outfile)
	execute 'edit '.a:outfile
	source %
endfunction

command! VimFontColorTest call VimFontColorTest('vim-color-test.tmp', 255, 255)




"0		  all attributes off
"1        foreground bright
"4        underscore on
"5        blink on/background bright (not reliable with brown)
"7        reverse-video
"8        set blank (non-display)
"10       set primary font
"11       set first alternate font (on PCs, display ROM characters 1-31)
"12       set second alternate font (on PCs, display IBM high-half chars)
"3n       set foreground color       / 0=black, 1=red,     2=green, 3=brown,
"4n       set background color        4=blue,  5=magenta, 6=cyan,  7=white

" echo "\e[7;48;5;94m SEARCH \e[0m"
"./ag --color-path="38;12;22" --color-line-number="38;5;22"  --color-match="48;5;94" color_line_number
""\e[a;b;c;dm" # where a, b, c, d are parameters
"puts "\e[1;4;32;47mtest" # output red on white, bold, underlined test

		
"https://code.google.com/p/conemu-maximus5/wiki/AnsiEscapeCodes






