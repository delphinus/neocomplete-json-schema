let s:V        = vital#of('neocomplete_json_schema')
let s:Filepath = s:V.import('System.Filepath')
let s:Prelude  = s:V.import('Prelude')

let s:class_name = 'neocomplete_json_schema_helper_pathname'
let s:pathname = {'_name': s:class_name}

function! s:pathname.relative_path_from(basepath) abort
  if s:Prelude.is_dict(a:basepath) && a:basepath._name ==# s:class_name
    let basepath = a:basepath
  else
    let basepath = neocomplete#sources#json_schema#helper#pathname#new(a:basepath)
  endif

  if ! ((self.is_relative && basepath.is_relative) || (self.is_absolute && basepath.is_absolute))
    throw 'pathnames must be both relative or both absolute.'
  endif

  let splitted = self.split()
  let basepath_splitted = basepath.split()

  let relative_path_splitted = []
  let level = 0
  if len(splitted) && len(basepath_splitted)
    while splitted[level] ==# basepath_splitted[level]
      let level += 1
    endwhile
  endif

  for i in range(len(basepath_splitted) - level - 1)
    call add(relative_path_splitted, '..')
  endfor

  for i in range(level + 1, len(splitted) - 1)
    call add(relative_path_splitted, splitted[i])
  endfor

  return s:Filepath.join(relative_path_splitted)
endfunction

function! s:pathname.split() abort
  return s:Filepath.split(self._path_string)
endfunction

function! neocomplete#sources#json_schema#helper#pathname#new(path_string) abort
  let pathname = deepcopy(s:pathname)
  let pathname._path_string = a:path_string
  let pathname.is_absolute = s:Filepath.is_absolute(a:path_string)
  let pathname.is_relative = s:Filepath.is_relative(a:path_string)
  return pathname
endfunction
