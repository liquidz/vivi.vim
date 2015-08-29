if exists('g:loaded_vivi')
  finish
endif
let g:loaded_vivi = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:vivi_mix_run_config')
  let g:vivi_mix_run_config = {}
endif

if !exists('g:vivi_mix_test_config')
  let g:vivi_mix_test_config = {}
endif

let s:mix_run_default_config = {
    \ 'command':           'mix',
    \ 'exec':              '%c run %s',
    \ 'hook/cd/directory': vivi#get_mix_root(expand('%:p:h')),
    \ }

let s:mix_test_default_config = {
    \ 'command':           'mix',
    \ 'exec':              '%c test --no-color',
    \ 'outputter':         'multi:buffer:quickfix',
    \ 'errorformat':       '%E\ %#%n)\ %.%#,%C\ %#%f:%l,%Z%.%#stacktrace:,%C%m,%.%#(%.%#Error)\ %f:%l:\ %m,%-G%.%#',
    \ 'hook/cd/directory': vivi#get_mix_root(expand('%:p:h')),
    \ }

let g:quickrun_config['mix_run'] = extend(s:mix_run_default_config, g:vivi_mix_run_config)
let g:quickrun_config['mix_test'] = extend(s:mix_test_default_config, g:vivi_mix_test_config)

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
command! MixDepsGet call quickrun#run({
    \ 'type': 'mix_run', 'exec': '%c deps.get'})
command! MixDepsUpdateAll call quickrun#run({
    \ 'type': 'mix_run', 'exec': '%c deps.update --all'})
command! MixTest call vivi#quickrun#mix_test()
command! MixTestForCurrentLine call vivi#quickrun#mix_test_for_current_line()
command! MixTestAgain call vivi#quickrun#mix_test_for_last_tested_line()

""
" Call `mix run`
nnoremap <silent> <Plug>(vivi_mix_run) :<C-u>MixRun<CR>
nnoremap <silent> <Plug>(vivi_mix_deps_get) :<C-u>MixDepsGet<CR>
nnoremap <silent> <Plug>(vivi_mix_deps_update_all) :<C-u>MixDepsUpdateAll<CR>

""
" Call `mix test`
nnoremap <silent> <Plug>(vivi_mix_test) :<C-u>MixTest<CR>

""
" Call `mix test` for current line
vnoremap <silent> <Plug>(vivi_mix_test_for_current_line)
    \ :<C-u>MixTestForCurrentLine<CR>

nnoremap <silent> <Plug>(vivi_mix_test_again) :<C-u>MixTestAgain<CR>

" default key mapping
if exists('g:vivi_enable_default_key_mappings')
    \ && g:vivi_enable_default_key_mappings
  " pipeline
  imap >> \|><Space>

  if !hasmapto('<Plug>(vivi_mix_run)')
    silent! nmap <Leader>r <Plug>(vivi_mix_run)
  endif

  if !hasmapto('<Plug>(vivi_mix_test_again)')
    silent! nmap <Leader>t <Plug>(vivi_mix_test_again)
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
