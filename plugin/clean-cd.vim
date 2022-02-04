if exists('g:loaded_cd_lens') | finish | endif 

let s:save_cpo = &cpo 
set cpo&vim          

command! -nargs=* Clear lua require('cd-lens').Clear())
command! -nargs=* CD lua require('cd-lens').CD(expand('<args>'))

let &cpo = s:save_cpo 
unlet s:save_cpo

let g:loaded_cd_lens = 1
