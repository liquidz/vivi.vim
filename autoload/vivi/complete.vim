let s:V  = vital#of('vivi')
let s:DL = s:V.import('Data.List')
let s:CP = s:V.import('ConcurrentProcess')

function! s:split_at_first_space(s) abort
  let i = stridx(a:s, ' ')
  if i !=# -1
    return [a:s[:i-1], a:s[i+1:]]
  else
    return [a:s, '']
  endif
endfunction

function! vivi#complete#findstart(line, col) abort
    let start = a:col
    while start > 0 && a:line[start - 1] =~# '\v[A-Za-z0-9.]'
      let start -= 1
    endwhile

    return start
endfunction

function! vivi#complete#module_name(keyword) abort
  if a:keyword ==# ''
    return ''
  endif
  let i = strridx(a:keyword, '.')
  if i ==# -1
    return a:keyword
  endif
  return a:keyword[0:i-1]
endfunction

function! s:module_functions(label, keyword) abort
  let mod       = vivi#complete#module_name(a:keyword)
  let query     = printf('Vivi.print_module_functions("%s")', mod)
  let [ok, out] = vivi#iex#queue(a:label, query)

  if !ok
    return []
  endif

  return split(out, '\v[\r\n]+')
endfunction

function! vivi#complete#candidate(fn) abort
  let [name, param] = s:split_at_first_space(a:fn)
  if param ==# ''
    return {}
  endif

  return {
      \ 'word':  name,
      \ 'abbr':  a:fn,
      \ 'kind':  'f',
      \ 'icase': 1
      \}
endfunction

""
" Omnifunc for Elixir.
"
function! vivi#complete#omni(findstart, base) abort
  if a:findstart
    let line  = getline('.')
    let start = col('.') - 1
    return vivi#complete#findstart(line, start)
  else
    let label = vivi#iex#of(expand('%:p:h'))
    let candidates = []
    for fn in s:module_functions(label, a:base)
      let c = vivi#complete#candidate(fn)
      if c !=# {}
        call add(candidates, c)
      endif
    endfor

    return candidates
  endif
endfunction

