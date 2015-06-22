let s:save_cpo = &cpo
set cpo&vim

let s:V        = vital#of('neocomplete_json_schema')
let s:Message  = s:V.import('Vim.Message')
let s:File     = s:V.import('System.File')
let s:Filepath = s:V.import('System.Filepath')
let s:Cache    = s:V.import('System.Cache.File')
let s:Prelude  = s:V.import('Prelude')
let s:JSON     = s:V.import('Web.JSON')

let s:schema_glob = s:Filepath.join(g:neocomplete_json_schema_directory, '**/*.json')
let s:cache_dir = s:Filepath.join(g:neocomplete_json_schema_work_dir, 'cache')
let s:cache = s:Cache.new({'cache_dir': s:cache_dir})

function! neocomplete#sources#json_schema#helper#init(plugin_top_dir) abort
  if exists('b:neocomplete_json_schema_candidate_cache')
    return
  endif

  call s:File.mkdir_nothrow(s:cache_dir, 'p')

  let b:neocomplete_json_schema_repo_name = s:repo_name()
  if b:neocomplete_json_schema_repo_name == ''
    call s:Message.warn('cannot determine project root directory')
    return
  endif

  echomsg b:neocomplete_json_schema_repo_name
  if s:cache.has(b:neocomplete_json_schema_repo_name)
    let candidate_cache = s:cache.get(b:neocomplete_json_schema_repo_name)
  else
    let raw_candidate_cache = s:create_candidate_cache()
    let candidate_cache = s:JSON.encode(raw_candidate_cache)
    call s:cache.set(b:neocomplete_json_schema_repo_name, candidate_cache)

    redraw!
    echo '[neocomplete-json-schema] created candidate cache'
  endif

  let b:neocomplete_json_schema_candidates = []
  let b:neocomplete_json_schema_candidates_json = ''
  let cmd = a:plugin_top_dir . '/bin/relpath.rb'
  let commandline = printf('%s "%s" "%s"',
        \ cmd,
        \ escape(candidate_cache, '"'),
        \ escape(expand('%:p'), '"'))
  let async = neocomplete#sources#json_schema#helper#async#new()
  call async.run(commandline, 'b:neocomplete_json_schema_candidates_json')
endfunction

function! s:create_candidate_cache() abort
  let schemas = s:Prelude.glob(s:Filepath.join(b:neocomplete_json_schema_repo_name, s:schema_glob))
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

function! s:repo_name() abort
  let b:neocomplete_json_schema_repo_name = s:Prelude.path2project_directory(expand('%'))
  return b:neocomplete_json_schema_repo_name
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
