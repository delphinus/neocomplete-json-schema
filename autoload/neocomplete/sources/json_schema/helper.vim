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

function! neocomplete#sources#json_schema#helper#init() abort
  if exists('b:neocomplete_json_schema_candidate_cache')
    return
  endif

  if ! neocomplete#util#has_vimproc()
    let b:neocomplete_json_schema_enabled = 0
    call s:Message.error('[neocomplete-json-schema] need vimproc')
    return
  endif

  call s:File.mkdir_nothrow(s:cache_dir, 'p')

  let repo_name = neocomplete#sources#json_schema#helper#repo_name()
  if s:cache.has(repo_name)
    let b:neocomplete_json_schema_candidate_cache = s:cache.get(repo_name)
  else
    let b:neocomplete_json_schema_candidate_cache = neocomplete#sources#json_schema#helper#create_candidate_cache()
    call s:cache.set(repo, b:neocomplete_json_schema_candidate_cache)

    redraw!
    echo '[neocomplete-json-schema] created candidate cache'
  endif

  let b:neocomplete_json_schema_enabled = 1
endfunction

function! neocomplete#sources#json_schema#helper#create_candidate_cache()
  return ['fukuoka', 'oita', 'miyazaki', 'kagoshima', 'kumamoto', 'saga', 'nagasaki']
endfunction

function! neocomplete#sources#json_schema#helper#repo_name()
  let sub = vimproc#popen2('cd /Users/delphinus/git ; pwd')
  let repo_name = ''
  while ! sub.stdout.eof
    let repo_name .= sub.stdout.read()
  endwhile
  let [cond, status] = sub.waitpid()
  echo [cond, status, repo_name]
  let b:neocomplete_json_schema_repo_name = 'some-repo'
  return b:neocomplete_json_schema_repo_name
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
