" vim: et sw=2 sts=2

" Plugin:      https://github.com/mhinz/vim-startify
" Description: A fancy start screen for Vim.
" Maintainer:  Marco Hinz <http://github.com/mhinz>

if exists("b:current_syntax")
  finish
endif

let s:sep = startify#get_separator()
let s:padding_left = repeat(' ', get(g:, 'startify_padding_left', 3))

syntax sync fromstart

execute 'syntax match StartifyBracket /.*\%'. (len(s:padding_left) + 6) .'c/ contains=
      \ StartifyNumber,
      \ StartifySelect'
syntax match StartifySpecial /\V<empty buffer>\|<quit>/
syntax match StartifyNumber  /^\s*\[\zs[^BSVT]\{-}\ze\]/
syntax match StartifySelect  /^\s*\[\zs[BSVT]\{-}\ze\]/
syntax match StartifyVar     /\$[^\/]\+/

" Append StartifyNumber at the end of each line
syntax match StartifyNumberEnd /\[[^BSVT]\{-}\]\s*$/ contained
syntax match StartifyFile    /.*/ contains=
      \ StartifyBracket,
      \ StartifyPath,
      \ StartifySpecial,
      \ StartifyNumberEnd

execute 'syntax match StartifySlash /\'. s:sep .'/'
execute 'syntax match StartifyPath /\%'. (len(s:padding_left) + 6) .'c.*\'. s:sep .'/ contains=StartifySlash,StartifyVar'

execute 'syntax region StartifyHeader start=/\%1l/ end=/\%'. (len(g:startify_header) + 2) .'l/'

if exists('g:startify_custom_footer')
  execute 'syntax region StartifyFooter start=/\%'. startify#get_lastline() .'l/ end=/\_.*/'
endif

if exists('b:startify.section_header_lines')
  for line in b:startify.section_header_lines
    execute 'syntax region StartifySection start=/\%'. line .'l/ end=/$/'
  endfor
endif

highlight default link StartifyBracket Delimiter
highlight default link StartifyFile    Identifier
highlight default link StartifyFooter  Title
highlight default link StartifyHeader  Title
highlight default link StartifyNumber  Number
highlight default link StartifyPath    Directory
highlight default link StartifySection Statement
highlight default link StartifySelect  Title
highlight default link StartifySlash   Delimiter
highlight default link StartifySpecial Comment
highlight default link StartifyVar     StartifyPath
highlight default link StartifyNumberEnd Number

" " Custom highlight for even lines
" highlight EvenLineBackground ctermbg=LightGrey guibg=#e2e2e2
" function! HighlightEvenLines()
"   let l:line = 1
"   while l:line <= line('$')
"     " Check if the line is part of StartifyHeader, StartifyFooter, or StartifySection
"     let l:skip = 0
"     for synid in synstack(l:line, 1)
"       let l:synname = synIDattr(synid, 'name')
"       if l:synname =~# 'StartifyHeader\|StartifyFooter\|StartifySection'
"         let l:skip = 1
"         break
"       endif
"     endfor
"
"     " Apply even-line background highlight if the line is not skipped
"     if !l:skip && l:line % 2 == 0
"       call matchadd('EvenLineBackground', '\%'.l:line.'l.*')
"     endif
"     let l:line += 1
"   endwhile
" endfunction
"
" " Call the function to highlight even lines
" call HighlightEvenLines()

let b:current_syntax = 'startify'
