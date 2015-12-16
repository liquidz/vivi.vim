let s:save_cpo = &cpo
set cpo&vim

let s:V   = vital#of('vivi')
let s:Str = s:V.import('Data.String')

function! vivi#module#_extract_name(line) abort
  let arr = split(s:Str.trim(a:line), '\v\s+')
  if len(arr) < 3
    return ''
  endif
  return arr[1]
endfunction

""
" Return current file's module name
"
function! vivi#module#name() abort
  let pos = getpos('.')
  call setpos('.', [0, 0, 0, 0])
  let [lnum, col] = searchpos('defmodule ', 'c')
  if lnum ==# 0 && col ==# 0
    return ''
  endif

  let name = vivi#module#_extract_name(getline(lnum))

  call setpos('.', pos)
  return name
endfunction

""
" Reload module
"
function! vivi#module#reload(module_name) abort
  if a:module_name ==# ''
    return 0
  endif

  echomsg printf('reloading: [%s]', a:module_name)

  let label = vivi#iex#of(expand('%:p:h'))
  let [ok, out] = vivi#iex#queue(label, printf('r(%s)', a:module_name))
  return ok
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
