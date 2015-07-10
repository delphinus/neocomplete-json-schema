#!/usr/bin/env ruby
task default: :ci
task test:    %i[flavor spec]
task ci:      %i[dump test]

task :dump do
  sh 'vim --version'
end

task :flavor do
  sh 'bundle exec vim-flavor test'
end

task :spec do
  sh 'bundle exec rspec --format documentation'
end
