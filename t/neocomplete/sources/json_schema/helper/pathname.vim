call vspec#hint({'sid': 'neocomplete#sources#json_schema#_sid()'})
runtime! autoload/neocomplete/sources/json_schema/helper/pathname.vim

function! s:instance(...)
  return neocomplete#sources#json_schema#helper#pathname#new(a:1)
endfunction

describe 'constructor'

  context 'when with absolute paths'

    it 'has valid _path_string'
      let path = '/path/to/some/file'
      let instance = s:instance(path)
      Expect instance._path_string ==# path
    end

    it 'is absolute'
      let path = '/path/to/some/file'
      let instance = s:instance(path)
      Expect instance.is_absolute to_be_true
    end

    it 'is not relative'
      let path = '/path/to/some/file'
      let instance = s:instance(path)
      Expect instance.is_relative to_be_false
    end
  end

  context 'when with relative paths'

    it 'has valid _path_string'
      let path = 'path/to/some/file'
      let instance = s:instance(path)
      Expect instance._path_string ==# path
    end

    it 'is not absolute'
      let path = '/path/to/some/file'
      let instance = s:instance(path)
      Expect instance.is_absolute to_be_true
    end

    it 'is relative'
      let path = '/path/to/some/file'
      let instance = s:instance(path)
      Expect instance.is_relative to_be_false
    end
  end
end
