let s:suite  = themis#suite('vivi test')
let s:assert = themis#helper('assert')

function! s:suite.findstart_test() abort
  let tests = [
      \ ['Enum',         4,  0],
      \ ['Enum.map',     5,  0],
      \ ['Enum.map',     6,  0],
      \ ['foo Enum',     6,  4],
      \ ['foo Enum.map', 9,  4],
      \ ['foo Enum.map', 10, 4]
      \ ]

  for [line, col, expected] in tests
    let actual = vivi#complete#findstart(line, col)
    call s:assert.equals(
        \ actual, expected,
        \ printf('line: %s, col: %d, lhs: %d, rhs: %d', line, col, actual, expected))
  endfor
endfunction

function! s:suite.module_name_test() abort
  let tests = [
      \ ['',            ''],
      \ ['Foo',         'Foo'],
      \ ['Foo.bar',     'Foo'],
      \ ['Foo.Bar.baz', 'Foo.Bar']]

  for [key, expected] in tests
    let actual = vivi#complete#module_name(key)
    call s:assert.equals(
        \ actual, expected,
        \ printf('key: %s, lhs: %s, rhs: %s', key, actual, expected))
  endfor
endfunction

function! s:suite.candidate_test() abort
  let actual = vivi#complete#candidate('Foo.bar 2')
  let expected = {
      \ 'word': 'Foo.bar',
      \ 'kind': 'f',
      \ 'menu': '/2',
      \ 'icase': 1
      \ }

  call s:assert.equals(actual, expected)
endfunction

