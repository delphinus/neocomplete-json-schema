let s:save_cpo = &cpo
set cpo&vim

function! neocomplete#filters#matcher_super_fuzzy#define() abort
  return s:matcher
endfunction

function! neocomplete#filters#matcher_super_fuzzy#escape(string) abort
  " Escape string for lua regexp.
  let result = []
  lua << EOF
do
  local string = vim.eval('a:string')
  local result = vim.eval('result')
  local result_string = ''
  local meta_char = '%[]().*+?^$-'
  for i = 1, #string do
    local char = string.sub(string, i, i)
    local escaped = string.find(meta_char, char) and '%' .. char or char
    result_string = result_string .. '.*' .. escaped
  end
  result:add(result_string)
end
EOF

  let string = result[0]

  if g:neocomplete#enable_camel_case && string =~# '\u'
    let string = substitute(string, '\l', '[\0\u\0\E]', 'g')
  endif
  return string
endfunction

let s:matcher = {
      \ 'name': 'matcher_super_fuzzy',
      \ 'description': 'super fuzzy matcher',
      \ }

function! s:matcher.filter(context) abort "{{{
  if len(a:context.complete_str) > 10
    " Mix fuzzy mode.
    let len = len(a:context.complete_str)
    let fuzzy_len = len - len/(1 + len/10)
    let pattern =
          \ neocomplete#filters#escape(
          \     a:context.complete_str[: fuzzy_len-1])  .
          \ neocomplete#filters#matcher_super_fuzzy#escape(
          \     a:context.complete_str[fuzzy_len :])
  else
    let pattern = neocomplete#filters#matcher_super_fuzzy#escape(
          \ a:context.complete_str)
  endif

  " The first letter must be matched.
  let pattern = '^' . pattern

  lua << EOF
do
  local pattern = vim.eval('pattern')
  local input = vim.eval('a:context.complete_str')
  local candidates = vim.eval('a:context.candidates')
  if vim.eval('&ignorecase') ~= 0 then
    pattern = string.lower(pattern)
    input = string.lower(input)
    for i = #candidates-1, 0, -1 do
      local word = vim.type(candidates[i]) == 'dict' and
        string.lower(candidates[i].word) or string.lower(candidates[i])
      if string.find(word, pattern, 1) == nil then
        candidates[i] = nil
      end
    end
  else
    for i = #candidates-1, 0, -1 do
      local word = vim.type(candidates[i]) == 'dict' and
        candidates[i].word or candidates[i]
      if string.find(word, pattern, 1) == nil then
        candidates[i] = nil
      end
    end
  end
end
EOF

  return a:context.candidates
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
