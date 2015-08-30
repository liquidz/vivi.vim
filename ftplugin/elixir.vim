if exists('g:loaded_vivi')
  finish
endif
let g:loaded_vivi = 1

let s:save_cpo = &cpo
set cpo&vim

""
" Change quickrun configration for `mix run`.
"
if !exists('g:vivi_mix_run_config')
  let g:vivi_mix_run_config = {}
endif

""
" Change quickrun configration for `mix test`.
"
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

""
" Run `mix run`.
"
command! MixRun call vivi#quickrun#mix_run()

""
" Run `mix deps.get`.
"
command! MixDepsGet call quickrun#run({
    \ 'type': 'mix_run', 'exec': '%c deps.get'})

""
" Run `mix deps.update --all`.
"
command! MixDepsUpdateAll call quickrun#run({
    \ 'type': 'mix_run', 'exec': '%c deps.update --all'})

""
" Run `mix test`.
"
command! MixTest call vivi#quickrun#mix_test()

""
" Run `mix test` for current line.
"
command! MixTestForCurrentLine call vivi#quickrun#mix_test_for_current_line()

""
" Run `mix test` as same as last testing condition.
"
command! MixTestAgain call vivi#quickrun#mix_test_for_last_tested_line()

""
" Call `:MixRun` command.
"
nnoremap <silent> <Plug>(vivi_mix_run) :<C-u>MixRun<CR>

""
" Call `:MixDepsGet` command.
"
nnoremap <silent> <Plug>(vivi_mix_deps_get) :<C-u>MixDepsGet<CR>

""
" Call `:MixDepsUpdateAll` command.
"
nnoremap <silent> <Plug>(vivi_mix_deps_update_all) :<C-u>MixDepsUpdateAll<CR>

""
" Call `:MixTest` command.
"
nnoremap <silent> <Plug>(vivi_mix_test) :<C-u>MixTest<CR>

""
" Call `:MixTestForCurrentLine` command.
"
vnoremap <silent> <Plug>(vivi_mix_test_for_current_line)
    \ :<C-u>MixTestForCurrentLine<CR>

""
" Call `:MixTestAgain` command.
"
nnoremap <silent> <Plug>(vivi_mix_test_again) :<C-u>MixTestAgain<CR>

""
" Enables default key mappings. (default: DISABLED)
"
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

""
" Enables auto syntax checking. (default: DISABLED)
"
if exists('g:vivi_enable_auto_syntax_checking')
    \ && g:vivi_enable_auto_syntax_checking
  let g:watchdogs_check_BufWritePost_enables = {
      \ 'elixir': 1
      \ }
endif

let &cpo = s:save_cpo
unlet s:save_cpo
