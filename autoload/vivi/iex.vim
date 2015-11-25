let s:save_cpo = &cpo
set cpo&vim

let s:V   = vital#of('vivi')
let s:Str = s:V.import('Data.String')
let s:DL  = s:V.import('Data.List')
let s:CP  = s:V.import('ConcurrentProcess')

" List of concurrent processes
let s:processes = get(s:, 'processes', [])

" Launch IEx concurrent process in a:dir,
" and return process label string.
function! vivi#iex#of(dir) abort
  let cmd = 'iex'
  let dir = vivi#get_mix_root(a:dir)
  if dir ==# ''
    let dir = a:dir
  else
    let cmd = cmd . ' -S mix'
  endif

  let label = s:CP.of(
      \ cmd, dir,
      \ [['*read*', '_', 'iex(.*)>\s*']])

  let s:processes = s:DL.uniq(s:processes + [label])

  return label
endfunction

" Add command to CP queue and wait process response.
function! vivi#iex#queue(label, line) abort
	call s:CP.queue(a:label, [
			\ ['*writeln*', a:line],
			\ ['*read*', 'result', 'iex(.*)>\s*']])

  let [out, err, timedout] = s:CP.consume_all_blocking(a:label, 'result', 5)
  if len(err) || timedout
		return [0, err]
  endif
  return [1, out]
endfunction

""
" Kill all iex concurrent processes.
"
function! vivi#iex#killall() abort
  for label in s:processes
    call s:CP.shutdown(label)
  endfor
  let s:processes = []
  echomsg 'Managed iex processes are killed.'
endfunction

""
" Warm up iex concurrent process in current directory.
"
function! vivi#iex#warmup() abort
  let label = vivi#iex#of(expand('%:p:h'))
endfunction

function! vivi#iex#_extract_module_name(line) abort
  let arr = split(s:Str.trim(a:line), '\v\s+')
  if len(arr) < 3
    return ''
  endif
  return arr[1]
endfunction

""
" Return current file's module name
"
function! vivi#iex#module_name() abort
  let pos = getpos('.')
  call setpos('.', [0, 0, 0, 0])
  let [lnum, col] = searchpos('defmodule ', 'c')
  if lnum ==# 0 && col ==# 0
    return ''
  endif

  let name = vivi#iex#_extract_module_name(getline(lnum))

  call setpos('.', pos)
  return name
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
