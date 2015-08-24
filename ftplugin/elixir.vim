if exists('g:loaded_vivi')
  finish
endif
let g:loaded_vivi = 1

let s:save_cpo = &cpo
set cpo&vim

""
" @var
" QuickRun Outputter for `mix test`.
" Default value is 'quickfix'.
"
if !exists('g:vivi_mix_test_outputter')
  let g:vivi_mix_test_outputter = 'quickfix'
endif

" mix test config
let g:quickrun_config['mix_test'] = {
    \ 'command':           'mix',
    \ 'exec':              '%c test',
    \ 'outputter':         'quickfix',
    \ 'errorformat':       '%E\ %#%n)\ %.%#,%C\ %#%f:%l,%Z%.%#stacktrace:,%C%m,%.%#(%.%#Error)\ %f:%l:\ %m,%-G%.%#',
    \ 'hook/cd/directory': vivi#get_mix_root(expand('%:p:h'))
    \ }

" watchdog config
let g:quickrun_config['watchdogs_checker/elixir'] = {
    \ 'command':           'elixir',
    \ 'exec':              '%c %s',
    \ 'errorformat':       '%.%#(%.%#Error)\ %f:%l:\ %m,%-G%.%#',
    \ 'hook/cd/directory': vivi#get_mix_root(expand('%:p:h'))
    \ }
let g:quickrun_config['elixir/watchdogs_checker'] = {
    \ 'type' : 'watchdogs_checker/elixir'
    \ }
call watchdogs#setup(g:quickrun_config)

""
" Call `mix test`
nnoremap <silent> <Plug>(mix_test) :<C-u>QuickRun mix_test<CR>

" default key mapping
if exists('g:vivi_enable_default_key_mappings')
    \ && g:vivi_enable_default_key_mappings
  " pipeline
  imap >> \|><Space>

  " mix test
  if !hasmapto('<Plug>(mix_test)')
    silent! nmap <unique> <Leader>t <Plug>(mix_test)
  endif
endif

let &cpo = s:save_cpo
unlet s:save_cpo
