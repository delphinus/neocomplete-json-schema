call vspec#hint({'sid': 'neocomplete#sources#json_schema#_sid()'})

function! s:instance(...)
  return neocomplete#sources#json_schema#helper#pathname#new(a:1)
endfunction

describe 'constructor'

  context 'when with absolute paths'

    before
      let g:some_path = '/path/to/some/file'
    end

    it 'has valid _path_string'
      let instance = s:instance(g:some_path)
      Expect instance._path_string ==# g:some_path
    end

    it 'is absolute'
      let instance = s:instance(g:some_path)
      Expect instance.is_absolute to_be_true
    end

    it 'is not relative'
      let instance = s:instance(g:some_path)
      Expect instance.is_relative to_be_false
    end
  end

  context 'when with relative paths'

    before
      let g:some_path = 'path/to/some/file'
    end

    it 'has valid _path_string'
      let instance = s:instance(g:some_path)
      Expect instance._path_string ==# g:some_path
    end

    it 'is not absolute'
      let instance = s:instance(g:some_path)
      Expect instance.is_absolute to_be_false
    end

    it 'is relative'
      let instance = s:instance(g:some_path)
      Expect instance.is_relative to_be_true
    end
  end
end

describe 'relative_path_from()'

  describe 'throwing'

    before
      let g:some_error = 'pathnames must be both relative or both absolute\.'
    end

    context 'when base is relative and target is absolute'

      it 'throw error'
        let base = s:instance('path/to/some/file')
        let target = s:instance('/path/to/some/file')
        Expect expr { target.relative_path_from(base) } to_throw g:some_error
      end
    end

    context 'when base is absolute and target is relative'

      it 'throw error'
        let base = s:instance('/path/to/some/file')
        let target = s:instance('path/to/some/file')
        Expect expr { target.relative_path_from(base) } to_throw g:some_error
      end
    end
  end
end
