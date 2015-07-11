task default: :ci
task test:    %i[flavor]
task ci:      %i[dump test]

task :dump do
  sh 'vim --version'
end

tests = %w[
  t/neocomplete/sources/json_schema/helper/pathname.vim
]

task :flavor do
  sh "bundle exec vim-flavor test t -v"
end

task :local do
  sh 'bundle exec vim-flavor test t -v'
end
