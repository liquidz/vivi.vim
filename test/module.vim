let s:suite  = themis#suite('vivi test')
let s:assert = themis#helper('assert')

function! s:suite._extract_name() abort
  let tests = [
      \ ['defmodule Foo do',     'Foo'],
      \ ['defmodule Foo.Bar do', 'Foo.Bar'],
      \ ['defmodule ',            ''],
      \ ['defmodule do',         ''],
      \ ]

  for [line, expected] in tests
    let actual = vivi#module#_extract_name(line)
    call s:assert.equals(
        \ actual, expected,
        \ printf('line: %s, lhs: %s, rhs: %s', line, actual, expected))
  endfor
endfunction
