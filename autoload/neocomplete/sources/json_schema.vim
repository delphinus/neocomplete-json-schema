let s:save_cpo = &cpo
set cpo&vim

let s:V       = vital#of('neocomplete_json_schema')
let s:Message = s:V.import('Vim.Message')

let s:source = {
      \ 'name':        'json_schema',
      \ 'kind':        'manual',
      \ 'filetypes':   {'json': 1},
      \ 'mark':        '[json-schema]',
      \ 'is_volatile': 1,
      \ 'rank':        100,
      \ 'hooks':       {},
      \ }

function! neocomplete#sources#json_schema#define()
  return s:source
endfunction

function! s:source.gather_candidates(...)
  if ! exists('b:neocomplete_json_schema_enabled')
    return []
  else
    return b:neocomplete_json_schema_candidate_cache
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
