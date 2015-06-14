let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_neocomplete_json_schema')
  finish
endif
let g:loaded_neocomplete_json_schema = 1

if !exists('g:neocomplete_json_schema_directory')
  let g:neocomplete_json_schema_directory = $HOME . '/.neocomplete-json-schema'
endif

let g:neocomplete_json_schema_dict = {'refs': []}

command! -nargs=? JsonSchemaMakeDict call neocomplete#sources#json_schema#helper#make_dict(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
