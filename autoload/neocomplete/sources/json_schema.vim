let s:save_cpo = &cpo
set cpo&vim

let s:source = {
      \ 'name':        'json_schema',
      \ 'kind':        'manual',
      \ 'filetypes':   {'json': 1},
      \ 'mark':        '[json-schema]',
      \ 'is_volatile': 1,
      \ 'rank':        100,
      \ 'hooks':       {},
      \ 'matchers':    ['matcher_fuzzy'],
      \ }

function! neocomplete#sources#json_schema#define() abort
  return s:source
endfunction

function! s:source.gather_candidates(...) abort
  if exists('b:neocomplete_json_schema_candidates') && len(b:neocomplete_json_schema_candidates)
    return deepcopy(b:neocomplete_json_schema_candidates)
  endif
endfunction

function! s:source.get_complete_position(context) abort
  return matchend(a:context.input, '"\$ref"\s*:\s*"')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
