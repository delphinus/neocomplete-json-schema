call vspec#hint({'sid': 'neocomplete#sources#json_schema#_sid()'})

function! s:instance(...)
  return neocomplete#sources#json_schema#helper#pathname#new(a:1)
endfunction

describe 'constructor'

  context 'when with absolute paths'

    before
      let s:path = '/path/to/some/file'
    end

    it 'has valid _path_string'
      let instance = s:instance(s:path)
      let path = s:path
      Expect instance._path_string ==# path
    end

    it 'is absolute'
      let instance = s:instance(s:path)
      Expect instance.is_absolute to_be_true
    end

    it 'is not relative'
      let instance = s:instance(s:path)
      Expect instance.is_relative to_be_false
    end
  end

  context 'when with relative paths'

    before
      let s:path = 'path/to/some/file'
    end

    it 'has valid _path_string'
      let instance = s:instance(s:path)
      let path = s:path
      Expect instance._path_string ==# path
    end

    it 'is not absolute'
      let instance = s:instance(s:path)
      Expect instance.is_absolute to_be_false
    end

    it 'is relative'
      let instance = s:instance(s:path)
      Expect instance.is_relative to_be_true
    end
  end
end
