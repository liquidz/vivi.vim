let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('vivi')
let s:FP = s:V.import('System.Filepath')

""
" @var
" File name to detect mix project root.
" Default value is 'mix.exs'.
"
if !exists('g:vivi#mix_name')
  let g:vivi#mix_name = 'mix.exs'
endif

function! s:is_system_root(dir) abort
  return (has('win32'))
      \ ? (match(a:dir, '\c^[A-Z]:\\$') ==# 0)
      \ : (a:dir ==# s:FP.separator())
endfunction

""
" Return mix project root directory.
" To detect root directory, |g:vivi#mix_name| is used.
"
function! vivi#get_mix_root(dir) abort
  let dir = expand(a:dir)
  if dir ==# '' || dir ==# '.'
    return ''
  endif

  let path = s:FP.join(dir, g:vivi#mix_name)
  if filereadable(path) || isdirectory(path)
    return dir
  endif

  return s:is_system_root(dir)
        \ ? ''
        \ : vivi#get_mix_root(s:FP.dirname(dir))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
