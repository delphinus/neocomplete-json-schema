let s:save_cpo = &cpo
set cpo&vim

let s:V        = vital#of('neocomplete_json_schema')
let s:Reunions = s:V.import('Reunions')

augroup neocomplete-json-schema-vimproc
augroup END

let s:async = {
      \ 'config': {
      \   'updatetime': 50,
      \ }}

function! s:async.run(command, resultvar) abort
  let self.process = s:Reunions.process(a:command)
  let self.process.resultvar = a:resultvar

  function! self.process.then(result, ...) abort
    execute 'let ' . self.resultvar . ' = "' . escape(a:result, '"') . '"'
    if self._autocmd
      autocmd! neocomplete-json-schema-vimproc
    endif
    if self._updatetime
      let &updatetime = self._updatetime
    endif
  endfunction

  augroup neocomplete-json-schema-vimproc
    autocmd!
    autocmd CursorHold * call s:Reunions.update_in_cursorhold(1)
  augroup END
  let self.process._autocmd = 1
  let self.process._updatetime = &updatetime
  let &updatetime = self.config.updatetime
endfunction

function! neocomplete#sources#json_schema#helper#async#new() abort
  return deepcopy(s:async)
endfunction

function! neocomplete#sources#json_schema#helper#async#log() abort
  return s:Reunions.log()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
