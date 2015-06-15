let s:save_cpo = &cpo
set cpo&vim

let s:V       = vital#of('neocomplete_json_schema')
let s:Message = s:V.import('Vim.Message')

let s:source = {
      \ 'name':        'json_schema',
      \ 'kind':        'manual',
      \ 'filetypes':   {'javascript': 1},
      \ 'mark':        '[json]',
      \ 'is_volatile': 1,
      \ 'rank':        100,
      \ 'hooks':       {},
      \ }

function! neocomplete#sources#json_schema#define()
  return s:source
endfunction

function! s:source.gather_candidates(...)
  return deepcopy(g:neocomplete_json_schema_dict.refs)
endfunction

function! s:source.hooks.on_init(context)
  if neocomplete#sources#json_schema#helper#has_candidate_cache()
    call neocomplete#sources#json_schema#helper#load_candidate_cache()
  endif

  if empty(g:neocomplete_json_schema_dict.refs)
    call s:Message.warn('no dictionary. run command :JsonSchemaMakeDict')
    sleep 3
    return
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
