task default: :ci
task test:    %i[flavor]
task ci:      %i[dump test]

task :dump do
  sh 'vim --version'
end

task :flavor do
  sh 'bundle exec vim-flavor test'
end

task :local do
  sh 'bundle exec vim-flavor test t'
end
