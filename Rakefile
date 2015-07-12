task default: :ci
task test:    %i[flavor]
task ci:      %i[dump test]

task :dump do
  sh 'vim --version'
end

tests = %w[
  t/neocomplete/filters/matcher_super_fuzzy.vim
  t/neocomplete/sources/json_schema/helper/pathname.vim
]

task :flavor do
  sh "bundle exec vim-flavor test #{tests.join ' '} -v"
end

task :local do
  sh 'bundle exec vim-flavor test t -v'
end
