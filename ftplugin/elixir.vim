if exists('g:loaded_vivi')
  finish
endif
let g:loaded_vivi = 1

let s:save_cpo = &cpo
set cpo&vim

let g:quickrun_config['mix_run'] = {
    \ 'command':           'mix',
    \ 'exec':              '%c run %s',
    \ 'hook/cd/directory': vivi#get_mix_root(expand('%:p:h')),
    \ }

" mix test config
let g:quickrun_config['mix_test'] = {
    \ 'command':                 'mix',
    \ 'exec':                    '%c test',
    \ 'outputter':               'error',
    \ 'outputter/error/success': 'message',
    \ 'outputter/error/error':   'quickfix',
    \ 'outputter/message/log':   1,
    \ 'errorformat':             '%E\ %#%n)\ %.%#,%C\ %#%f:%l,%Z%.%#stacktrace:,%C%m,%.%#(%.%#Error)\ %f:%l:\ %m,%-G%.%#',
    \ 'hook/cd/directory':       vivi#get_mix_root(expand('%:p:h')),
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

command! MixRun call vivi#quickrun#mix_run()
command! MixTest call quickrun#run('mix_test')
command! MixTestForCurrentLine call vivi#quickrun#mix_test_for_current_line()

""
" Call `mix run`
nnoremap <silent> <Plug>(vivi_mix_run)
    \ :<C-u>MixRun<CR>

""
" Call `mix test`
nnoremap <silent> <Plug>(vivi_mix_test)
    \ :<C-u>MixTest<CR>

""
" Call `mix test` for current line
vnoremap <silent> <Plug>(vivi_mix_test_for_current_line)
    \ :<C-u>MixTestForCurrentLine<CR>

" default key mapping
if exists('g:vivi_enable_default_key_mappings')
    \ && g:vivi_enable_default_key_mappings
  " pipeline
  imap >> \|><Space>

  if !hasmapto('<Plug>(vivi_mix_run)')
    silent! nmap <Leader>r <Plug>(vivi_mix_run)
  endif

  if !hasmapto('<Plug>(vivi_mix_test)')
    silent! nmap <Leader>t <Plug>(vivi_mix_test)
  endif

  if !hasmapto('<Plug>(vivi_mix_test_for_current_line)')
    silent! vmap <Leader>t <Plug>(vivi_mix_test_for_current_line)
  endif
endif

" auto syntax checking
if exists('g:vivi_enable_auto_syntax_checking')
    \ && g:vivi_enable_auto_syntax_checking
  let g:watchdogs_check_BufWritePost_enables = {
      \ 'elixir': 1
      \ }
endif

let &cpo = s:save_cpo
unlet s:save_cpo
