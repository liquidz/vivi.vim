if exists('g:loaded_vivi')
  finish
endif
let g:loaded_vivi = 1

let s:save_cpo = &cpo
set cpo&vim

"""" Error Format {{{
let s:test_errorformat = join([
    \ '%E\ %#%n)\ %.%#',
    \ '%C\ %#%f:%l',
    \ '%Z%.%#stacktrace:',
    \ '%C%m',
    \ '%.%#(%.%#Error)\ %f:%l:\ %m',
    \ '%-G%.%#'
    \ ], ',')

let s:lint_errorformat = join([
    \ '%.%#(%.%#Error)\ %f:%l:\ %m',
    \ '%-G%.%#'
    \ ], ',')
"""" }}}

"""" Commands {{{

""
" Run `mix run`.
"
command! ViviMixRun call vivi#quickrun#mix_run()

""
" Run `mix deps.get`.
"
command! ViviMixDepsGet call quickrun#run({
    \ 'type': 'mix_run', 'exec': '%c deps.get'})

""
" Run `mix deps.update --all`.
"
command! ViviMixDepsUpdateAll call quickrun#run({
    \ 'type': 'mix_run', 'exec': '%c deps.update --all'})

""
" Run `mix test`.
"
command! ViviMixTest call vivi#quickrun#mix_test()

""
" Run `mix test` for current line.
"
command! ViviMixTestForCurrentLine call vivi#quickrun#mix_test_for_current_line()

""
" Run `mix test` as same as last testing condition.
"
command! ViviMixTestAgain call vivi#quickrun#mix_test_for_last_tested_line()

""
" Kill all IEx processes
"
command! ViviKillAllIEx call vivi#iex#killall()

"""" }}}

"""" Key Mappings {{{

""
" Call `:ViviMixRun` command.
"
nnoremap <silent> <Plug>(vivi_mix_run) :<C-u>ViviMixRun<CR>

""
" Call `:ViviMixDepsGet` command.
"
nnoremap <silent> <Plug>(vivi_mix_deps_get) :<C-u>ViviMixDepsGet<CR>

""
" Call `:ViviMixDepsUpdateAll` command.
"
nnoremap <silent> <Plug>(vivi_mix_deps_update_all) :<C-u>ViviMixDepsUpdateAll<CR>

""
" Call `:ViviMixTest` command.
"
nnoremap <silent> <Plug>(vivi_mix_test) :<C-u>ViviMixTest<CR>

""
" Call `:ViviMixTestForCurrentLine` command.
"
vnoremap <silent> <Plug>(vivi_mix_test_for_current_line)
    \ :<C-u>ViviMixTestForCurrentLine<CR>

""
" Call `:ViviMixTestAgain` command.
"
nnoremap <silent> <Plug>(vivi_mix_test_again) :<C-u>ViviMixTestAgain<CR>

""
" Call `:ViviKillAllIEx` command.
"
nnoremap <silent> <Plug>(vivi_kill_all_iex) :<C-u>ViviKillAllIEx<CR>

function! s:default_key_mappings() abort
  " pipeline
  imap <buffer> >> \|><Space>

  if !hasmapto('<Plug>(vivi_mix_run)')
    silent! nmap <buffer> <Leader>r <Plug>(vivi_mix_run)
  endif

  if !hasmapto('<Plug>(vivi_mix_test_again)')
    silent! nmap <buffer> <Leader>t <Plug>(vivi_mix_test_again)
  endif

  if !hasmapto('<Plug>(vivi_mix_test_for_current_line)')
    silent! vmap <buffer> <Leader>t <Plug>(vivi_mix_test_for_current_line)
  endif

  if !hasmapto('<Plug>(vivi_kill_all_iex)')
    silent! nmap <buffer> <Leader>vk <Plug>(vivi_kill_all_iex)
  endif
endfunction
"""" }}}

"""" Omni Completion {{{
function! s:set_omnifunc() abort
  setlocal omnifunc=vivi#complete#omni

  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  let g:neocomplete#sources#omni#input_patterns.elixir = '[^.[:digit:] *\t]\.'
endfunction
"""" }}}

"""" Customizing {{{

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

""
" Enables default key mappings. (default: DISABLED)
"
if exists('g:vivi_enable_default_key_mappings')
    \ && g:vivi_enable_default_key_mappings
  silent! call s:default_key_mappings()
  aug ViviDefaultKeyMappings
    au!
    au FileType elixir call s:default_key_mappings()
  aug END
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

""
" Enables auto warm up IEx concurrent process. (default: DISABLED)
"
if exists('g:vivi_enable_auto_warm_up_iex')
    \ && g:vivi_enable_auto_warm_up_iex
  silent! call vivi#iex#warmup()
endif

""
" Enable omni completion. (default: DISABLED)
" Omnifunc is `vivi#complete#omni`.
"
if exists('g:vivi_enable_omni_completion')
    \ && g:vivi_enable_omni_completion
  silent! call s:set_omnifunc()
  aug ViviOmniCompletion
    au!
    au FileType elixir call s:set_omnifunc()
  aug END
endif

" quickrun config {{{
let s:mix_run_default_config = {
    \ 'command':           'mix',
    \ 'exec':              '%c run %s',
    \ 'hook/cd/directory': vivi#get_mix_root(expand('%:p:h')),
    \ }

let s:mix_test_default_config = {
    \ 'command':           'mix',
    \ 'exec':              '%c test --no-color',
    \ 'outputter':         'multi:buffer:quickfix',
    \ 'errorformat':       s:test_errorformat,
    \ 'hook/cd/directory': vivi#get_mix_root(expand('%:p:h')),
    \ }

if !exists('g:quickrun_config')
  let g:quickrun_config = {}
endif

let g:quickrun_config['mix_run'] =
    \ extend(s:mix_run_default_config, g:vivi_mix_run_config)
let g:quickrun_config['mix_test'] =
    \ extend(s:mix_test_default_config, g:vivi_mix_test_config)
" }}}

" watchdog config {{{
let g:quickrun_config['watchdogs_checker/elixir'] = {
    \ 'command':           'elixir',
    \ 'exec':              '%c %s',
    \ 'errorformat':       s:lint_errorformat,
    \ 'hook/cd/directory': vivi#get_mix_root(expand('%:p:h'))
    \ }
let g:quickrun_config['elixir/watchdogs_checker'] = {
    \ 'type' : 'watchdogs_checker/elixir'
    \ }
call watchdogs#setup(g:quickrun_config)
" }}}

"""" }}}

"""" Auto Commands {{{
aug ViviKillIExWhenLeave
  au!
  au VimLeave * call vivi#iex#killall()
aug END
"""" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" vim:fdl=0
