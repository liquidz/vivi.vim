let s:suite  = themis#suite('vivi test')
let s:assert = themis#helper('assert')

let s:V  = vital#of('vivi')
let s:FP = s:V.import('System.Filepath')

function! s:suite.get_mix_root_test() abort
  let root_dir        = getcwd()
  let test_dir        = s:FP.join(root_dir, 'test')
  let g:vivi#mix_name = 'README.md'

  call s:assert.equals(
      \ vivi#get_mix_root(test_dir),
      \ root_dir)
endfunction

function! s:suite.get_mix_root_error_test() abort
  call s:assert.equals(
      \ vivi#get_mix_root('.'),
      \ '')
endfunction
