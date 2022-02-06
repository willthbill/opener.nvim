if exists('g:loaded_opener') | finish | endif 

let s:save_cpo = &cpo 
set cpo&vim          

let LuaClear = luaeval('require("opener").clear')
let LuaOpen = luaeval('require("opener").open')

command! -nargs=0 Clear call LuaClear()
command! -nargs=1 -complete=dir Open call LuaOpen(expand('<args>'))

let &cpo = s:save_cpo 
unlet s:save_cpo

let g:loaded_opener = 1
