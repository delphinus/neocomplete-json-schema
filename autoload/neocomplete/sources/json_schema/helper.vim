let s:save_cpo = &cpo
set cpo&vim

let s:V        = vital#of('neocomplete-json-schema')
let s:Message  = s:V.import('Vim.Message')
let s:File     = s:V.import('System.File')
let s:Filepath = s:V.import('System.Filepath')
let s:Cache    = s:V.import('System.Cache.File')

let s:work_dir = g:neocomplete_json_schema_directory . '/'
let s:cache_dir = s:work_dir . 'cache/'
let s:cache = s:Cache.new({'cache_dir': s:cache_dir})

function! neocomplete#sources#json_schema#helper#make_dict(...)
  let [key, value] = neocomplete#sources#json_schema#helper#get_refs()

  let g:neocomplete_json_schema_dict.refs = value
  call s:File.mkdir_nothrow(s:cache_dir, 'p')
  call s:cache.set(key, value)

  redraw!
  echo 'finish.'
endfunction

function! neocomplete#sources#json_schema#helper#get_refs()
  return ['some-repo', ['a', 'b', 'c', 'd', 'e']]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
