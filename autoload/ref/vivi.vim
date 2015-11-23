let s:save_cpo = &cpo
set cpo&vim

let s:source = {'name': 'vivi'}
let s:invalid_chars = '\v[()''" \t]'

function! s:source.available() abort
  let CP = vital#of('vivi').import('ConcurrentProcess')
	return CP.is_available()
endfunction

function! s:source.get_body(query) abort
  let query = substitute(a:query, s:invalid_chars, '', 'g')
  let label = vivi#iex#of(expand('%:p:h'))

  let [ok, out] = vivi#iex#queue(label, printf('h(%s)', query))
  if !ok
    throw printf('No document found for "%s"', a:query)
  endif

  return out
endfunction

function! s:source.get_keyword() abort
  let isk = &l:iskeyword
  setlocal iskeyword+=.
  let keyword = expand('<cword>')
  let &l:iskeyword = isk
  return keyword
endfunction

function! s:source.opened(query) abort
  call s:syntax()
endfunction

function! s:syntax() abort
  syn clear
  syn match  exDocFunction '\v^\*\s+.+'
  syn match  exDocHeader   '\v^##\s+.+'
  syn region exKeyword     start="`" end="`"
  syn match  exDocContent  '\v^\s{4}.+'
  hi def link exDocFunction Function
  hi def link exDocHeader   Delimiter
  hi def link exKeyword     Keyword
  hi def link exDocContent  Define

  let b:current_syntax = 'ref-vivi'
endfunction

function! ref#vivi#define() abort
  return copy(s:source)
endfunction

call ref#register_detection('elixir', 'vivi')

let &cpo = s:save_cpo
unlet s:save_cpo
