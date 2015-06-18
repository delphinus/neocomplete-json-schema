#!/usr/bin/env ruby
require 'json'
require 'pathname'

current = Pathname ARGV[1]
candidates = JSON.parse(ARGV[0]).each_with_object [] do |(filename, candidate), ary|
  relpath = Pathname(filename).relative_path_from current
  candidate.each do |c|
    ary << "#{relpath}#definitions/#{c}"
  end
end
puts JSON.generate candidates
