call vspec#hint({'sid': 'neocomplete#sources#json_schema#_sid()'})
runtime! autoload/neocomplete/sources/json_schema/helper/pathname.vim

function! s:instance(...)
  return neocomplete#sources#json_schema#helper#pathname#new(a:1)
endfunction

describe 'constructor'

  context 'instance has valid properties'

    it 'has _path_string'
      let path = '/path/to/some/file'
      let instance = s:instance(path)
      Expect instance._path_string ==# path
    end
  end
end
