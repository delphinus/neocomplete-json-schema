let s:save_cpo = &cpo
set cpo&vim

let s:V       = vital#of('neocomplete_json_schema')
let s:Message = s:V.import('Vim.Message')
let s:JSON    = s:V.import('Web.JSON')

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
  if ! len(b:neocomplete_json_schema_candidates) && len(b:neocomplete_json_schema_candidates_json)
    let b:neocomplete_json_schema_candidates = s:JSON.decode(b:neocomplete_json_schema_candidates_json)
  endif
  return b:neocomplete_json_schema_candidates
endfunction

function! s:source.get_complete_position(context)
  return matchend(a:context.input, '"\$ref"\s*:\s*"')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
