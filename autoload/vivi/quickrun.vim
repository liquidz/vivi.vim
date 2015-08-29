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
    unlet g:vivi#quickrun#tested_file
  endif

  call quickrun#run('mix_test')
endfunction

function! vivi#quickrun#mix_test_for_current_line(...) abort
  let current_line = (a:0 ==# 1 || a:0 ==# 2) ? a:1 : line('.')
  let current_file = (a:0 ==# 2) ? a:2 : expand('%:p')

  let g:vivi#quickrun#tested_line = current_line
  let g:vivi#quickrun#tested_file = current_file

  call quickrun#run({
      \ 'type': 'mix_test',
      \ 'exec': '%c test ' . current_file . ':' . current_line
      \ })
endfunction

function! vivi#quickrun#mix_test_for_last_tested_line() abort
  if exists('g:vivi#quickrun#tested_line') && exists('g:vivi#quickrun#tested_file')
    call vivi#quickrun#mix_test_for_current_line(
        \ g:vivi#quickrun#tested_line,
        \ g:vivi#quickrun#tested_file
        \ )
  else
    call vivi#quickrun#mix_test()
  endif
endfunction
