source t/helpers/setup.vim

if ! has('lua')
  finish
endif

describe 'escape()'

  context 'when g:neocomplete#enable_camel_case is off'

    before
      let g:neocomplete#enable_camel_case = 0
    end

    context 'when string is null'

      it 'returns valid regex'
        Expect neocomplete#filters#matcher_super_fuzzy#escape('') ==# ''
      end
    end

    context 'when string is simple words'

      it 'returns valid regex'
        Expect neocomplete#filters#matcher_super_fuzzy#escape('aiueo') ==# '.*a.*i.*u.*e.*o'
      end
    end

    context 'when string has meta chars only'

      it 'returns valid regex'
        Expect neocomplete#filters#matcher_super_fuzzy#escape('.*+?') ==# '.*%..*%*.*%+.*%?'
      end
    end

    context 'when string has simple words and meta chars'

      it 'returns valid regex'
        Expect neocomplete#filters#matcher_super_fuzzy#escape('a.b*c') ==# '.*a.*%..*b.*%*.*c'
      end
    end
  end
end
