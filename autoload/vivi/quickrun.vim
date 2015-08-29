function! vivi#quickrun#mix_run() abort
  if &filetype ==# 'elixir'
    let root = vivi#get_mix_root(expand('%:p:h'))
    if root ==# ''
      call quickrun#run('elixir')
    else
      call quickrun#run('mix_run')
    endif
  else
    call quickrun#run()
  endif
endfunction

function! vivi#quickrun#mix_test() abort
  if exists('g:vivi#quickrun#tested_line')
    unlet g:vivi#quickrun#tested_line
  endif

  call quickrun#run('mix_test')
endfunction

function! vivi#quickrun#mix_test_for_current_line(...) abort
  let current_line = (a:0 ==# 1) ? a:1 : line('.')
  let g:vivi#quickrun#tested_line = current_line
  call quickrun#run({
      \ 'type': 'mix_test',
      \ 'exec': '%c test %s:' . current_line
      \ })
endfunction

function! vivi#quickrun#mix_test_for_last_tested_line() abort
  if exists('g:vivi#quickrun#tested_line')
    call vivi#quickrun#mix_test_for_current_line(g:vivi#quickrun#tested_line)
  else
    call vivi#quickrun#mix_test()
  endif
endfunction
