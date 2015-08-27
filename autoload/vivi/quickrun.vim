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

function! vivi#quickrun#mix_test_for_current_line() abort
  let current_line = line('.')
  call quickrun#run({
      \ 'type': 'mix_test',
      \ 'exec': '%c test %s:' . current_line
      \ })
endfunction

