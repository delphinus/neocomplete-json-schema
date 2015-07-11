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

  describe 'calculating'

    context 'when paths are relative'

      context 'when base is `basename`'

        before
          let g:some_base = 'hoge'
        end

        context 'when target is also a `basename` path'

          context 'when target is not base'

            it 'returns values validly'
              let base = g:some_base
              let target = s:instance('page')
              let result = '../page'
              Expect target.relative_path_from(base) ==# result
            end
          end

          context 'when target is base'

            it 'returns values validly'
              let base = g:some_base
              let target = s:instance(base)
              let result = '.'
              Expect target.relative_path_from(base) ==# result
            end
          end
        end

        context 'when target is a deep path'

          context 'when target exists on other path than base completely'

            it 'returns values validly'
              let base = g:some_base
              let target = s:instance('some/deep/path/to/file')
              let result = '../some/deep/path/to/file'
              Expect target.relative_path_from(base) ==# result
            end
          end

          context 'when target is descendant of base'

            it 'returns values validly'
              let base = g:some_base
              let target = s:instance('hoge/deep/path/to/file')
              let result = 'deep/path/to/file'
              Expect target.relative_path_from(base) ==# result
            end
          end
        end
      end

      context 'when base is a deep path'

        before
          let g:some_base = 'some/deep/path/to/file'
        end

        context 'when target is a `basename` path'

          context 'when target exists on other path than base completely'

            it 'returns values validly'
              let base = g:some_base
              let target = s:instance('page')
              let result = '../../../../../page'
              Expect target.relative_path_from(base) ==# result
            end
          end

          context 'when target is ancestor of base'

            it 'returns values validly'
              let base = g:some_base
              let target = s:instance('some')
              let result = '../../../..'
              Expect target.relative_path_from(base) ==# result
            end
          end
        end

        context 'when target is a deep path'

          context 'when target is base'

            it 'returns values validly'
              let base = g:some_base
              let target = s:instance(base)
              let result = '.'
              Expect target.relative_path_from(base) ==# result
            end
          end

          context 'when target is not base'

            context 'when target exists on other path completely'

              it 'returns values validly'
                let base = g:some_base
                let target = s:instance('other/deep/path/to/file')
                let result = '../../../../../other/deep/path/to/file'
                Expect target.relative_path_from(base) ==# result
              end
            end

            context 'when target is descendant of base'

              it 'returns values validly'
                let base = g:some_base
                let target = s:instance('some/deep/path/to/file/deeper/to/deeper')
                let result = 'deeper/to/deeper'
                Expect target.relative_path_from(base) ==# result
              end
            end

            context 'when target is ancestor of base'

              it 'returns values validly'
                let base = g:some_base
                let target = s:instance('some/deep/path')
                let result = '../..'
                Expect target.relative_path_from(base) ==# result
              end
            end

            context 'when target has a part of base'

              it 'returns values validly'
                let base = g:some_base
                let target = s:instance('some/deep/another/path')
                let result = '../../../another/path'
                Expect target.relative_path_from(base) ==# result
              end
            end
          end
        end
      end
    end
  end
end
