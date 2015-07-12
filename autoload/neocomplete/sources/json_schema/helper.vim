let s:save_cpo = &cpo
set cpo&vim

let s:V        = vital#of('neocomplete_json_schema')
let s:Message  = s:V.import('Vim.Message')
let s:File     = s:V.import('System.File')
let s:Filepath = s:V.import('System.Filepath')
let s:Cache    = s:V.import('System.Cache')
let s:Prelude  = s:V.import('Prelude')
let s:JSON     = s:V.import('Web.JSON')

let s:schema_glob = s:Filepath.join(g:neocomplete#json_schema_directory, '**/*.json')
let s:cache_dir = s:Filepath.join(g:neocomplete#json_schema_work_dir, 'cache')
call s:File.mkdir_nothrow(s:cache_dir, 'p')
let s:file_cache = s:Cache.new('file', {'cache_dir': s:cache_dir})
let s:memory_cache = s:Cache.new('memory')
let s:cache_key_header = {
      \ 'candidates': 'neocomplete-json-schema-candidates:',
      \ 'revision':   'neocomplete-json-schema-revision:',
      \ }

function! neocomplete#sources#json_schema#helper#init() abort
  let b:neocomplete_json_schema_candidates = []
  let repo_dir = s:Prelude.path2project_directory(expand('%'))
  if repo_dir ==# ''
    call s:Message.warn('[neocomplete-json-schema] cannot determine project root directory')
    return
  endif

  let current_revision = s:get_current_revision(repo_dir)
  let cache_key = s:cache_key_header.candidates . repo_dir
  let is_latest = s:is_cache_latest(repo_dir, current_revision)

  if is_latest && s:memory_cache.has(cache_key)
    let candidates = s:memory_cache.get(cache_key)
  elseif is_latest && s:file_cache.has(cache_key)
    let candidates = s:file_cache.get(cache_key)
    call s:memory_cache.set(cache_key, candidates)
  else
    let candidates = s:create_candidate_cache(repo_dir)
    if s:Prelude.is_dict(candidates) && len(candidates)
      call s:memory_cache.set(cache_key, candidates)
      call s:file_cache.set(cache_key, candidates)
      call s:set_revision_cache(repo_dir, current_revision)
      redraw!
      echo '[neocomplete-json-schema] created candidate cache'
    else
      redraw!
      call s:Message.warn('[neocomplete-json-schema] candidate cache cannot be created')
      return
    endif
  endif

  let b:neocomplete_json_schema_candidates = s:arrange_pathname(candidates)
endfunction

function! s:is_cache_latest(repo_dir, current_revision) abort
  let cache_key = s:cache_key_header.revision . a:repo_dir
  if ! s:file_cache.has(cache_key)
    return 0
  endif
  let last_revision = s:file_cache.get(cache_key)
  return last_revision ==# a:current_revision
endfunction

function! s:set_revision_cache(repo_dir, current_revision) abort
  let cache_key = s:cache_key_header.revision . a:repo_dir
  call s:file_cache.set(cache_key, a:current_revision)
endfunction

function! s:get_current_revision(repo_dir) abort
  let cmd = printf('git --git-dir="%s" rev-parse HEAD', s:Filepath.join(a:repo_dir, '.git'))
  return substitute(system(cmd), '\n', '', '')
endfunction

function! s:arrange_pathname(raw_candidates) abort
  let current_file = neocomplete#sources#json_schema#helper#pathname#new(expand('%:p'))
  let candidates = []
  for target in keys(a:raw_candidates)
    let definitions = a:raw_candidates[target]
    let target_path = neocomplete#sources#json_schema#helper#pathname#new(target)
    let relative_path = target_path.relative_path_from(current_file)
    for def in definitions
      call add(candidates, relative_path . '#definitions/' . def)
    endfor
  endfor

  return candidates
endfunction

function! s:create_candidate_cache(repo_dir) abort
  let schemas = s:Prelude.glob(s:Filepath.join(a:repo_dir, s:schema_glob))
  let candidates = {}

  for filename in schemas
    let definitions = s:read_definitions(filename)
    if s:Prelude.is_list(definitions)
      let candidates[filename] = definitions
    endif
    unlet definitions
  endfor

  return candidates
endfunction

function! s:read_definitions(filename) abort
  let decoded = s:decode_json(a:filename)
  if ! s:Prelude.is_dict(decoded)
    return 0
  endif
  let definitions_dict = get(decoded, 'definitions')
  if ! s:Prelude.is_dict(definitions_dict)
    return 0
  endif

  return keys(definitions_dict)
endfunction

function! s:decode_json(filename) abort
  let json = join(readfile(a:filename))
  try
    let decoded = s:JSON.decode(json)
  catch
    call s:Message.error('JSON broken: ' . a:filename)
    return
  endtry

  return decoded
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
