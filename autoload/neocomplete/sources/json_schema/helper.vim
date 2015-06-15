let s:save_cpo = &cpo
set cpo&vim

let s:V        = vital#of('neocomplete_json_schema')
let s:Message  = s:V.import('Vim.Message')
let s:File     = s:V.import('System.File')
let s:Filepath = s:V.import('System.Filepath')
let s:Cache    = s:V.import('System.Cache.File')

let s:work_dir = g:neocomplete_json_schema_directory . '/'
let s:cache_dir = s:work_dir . 'cache/'
let s:cache = s:Cache.new({'cache_dir': s:cache_dir})

function! neocomplete#sources#json_schema#helper#init()
  if exists('b:neocomplete_json_schema_candidate_cache')
    return
  endif

  if neocomplete#sources#json_schema#helper#has_candidate_cache()
    call neocomplete#sources#json_schema#helper#load_candidate_cache()
  else
    call neocomplete#sources#json_schema#helper#create_candidate_cache()
  endif
endfunction

function! neocomplete#sources#json_schema#helper#create_candidate_cache()
  let [key, value] = neocomplete#sources#json_schema#helper#load_refs()

  let b:neocomplete_json_schema_candidate_cache = value
  call s:File.mkdir_nothrow(s:cache_dir, 'p')
  call s:cache.set(key, value)

  redraw!
  echo '[neocomplete-json-schema] created candidate cache'
endfunction

function! neocomplete#sources#json_schema#helper#has_candidate_cache()
  let repo_name = neocomplete#sources#json_schema#helper#repo_name()
  return s:cache.has(repo_name)
endfunction

function! neocomplete#sources#json_schema#helper#load_candidate_cache()
  let repo_name = neocomplete#sources#json_schema#helper#repo_name()
  let b:neocomplete_json_schema_candidate_cache = s:cache.get(repo_name)
endfunction

function! neocomplete#sources#json_schema#helper#repo_name()
  let b:neocomplete_json_schema_repo_name = 'some-repo'
  return b:neocomplete_json_schema_repo_name
endfunction

function! neocomplete#sources#json_schema#helper#load_refs()
  let repo_name = neocomplete#sources#json_schema#helper#repo_name()
  return [repo_name, ['fukuoka', 'oita', 'miyazaki', 'kagoshima', 'kumamoto', 'saga', 'nagasaki']]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
