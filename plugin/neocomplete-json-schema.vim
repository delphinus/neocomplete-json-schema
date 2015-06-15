let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_neocomplete_json_schema')
  finish
endif
let g:loaded_neocomplete_json_schema = 1

augroup NeoCompleteJsonSchema
  autocmd!
  autocmd BufRead,BufNewFile *.json
        \ if getline(1) . getline(2) =~# '\$schema'
        \   | let b:neocomplete_json_schema_enabled = 1
        \   | call neocomplete#sources#json_schema#helper#init()
        \   | endif
augroup END

if !exists('g:neocomplete_json_schema_directory')
  let g:neocomplete_json_schema_directory = $HOME . '/.neocomplete-json-schema'
endif

let &cpo = s:save_cpo
unlet s:save_cpo
