let s:save_cpo = &cpo
set cpo&vim

let s:source = {'name': 'vivi'}

function! s:source.available()
  let CP = vital#of('vivi').import('ConcurrentProcess')
	return CP.is_available()
endfunction

function! s:source.get_body(query)
  let label = vivi#iex#of(expand('%:p:h'))

  let [ok, out] = vivi#iex#queue(label, printf('h(%s)', a:query))
  if !ok
    throw printf('No document found for "%s"', a:query)
  endif

  return out
endfunction

function! ref#vivi#define()
  return copy(s:source)
endfunction

call ref#register_detection('elixir', 'vivi')

let &cpo = s:save_cpo
unlet s:save_cpo
