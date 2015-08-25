function! vivi#quickrun#mix_test_for_current_line() abort
  let current_line = line('.')
  call quickrun#run({
      \ 'type': 'mix_test',
      \ 'exec': '%c test %s:' . current_line
      \ })
endfunction

